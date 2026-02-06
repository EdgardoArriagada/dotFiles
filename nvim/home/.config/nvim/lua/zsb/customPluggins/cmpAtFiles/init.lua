local source = {}

function source.new()
	return setmetatable({}, { __index = source })
end

function source:get_debug_name()
	return "at_files"
end

function source:get_trigger_characters()
	return { "@" }
end

function source:get_keyword_pattern()
	return [[@\S*]]
end

function source:is_available()
	return vim.bo.filetype == "markdown"
end

local lua_special = {
	["("] = true,
	[")"] = true,
	["."] = true,
	["%"] = true,
	["+"] = true,
	["-"] = true,
	["^"] = true,
	["$"] = true,
}

--- Convert a gitignore glob into an anchored Lua pattern string.
local function glob_to_lua_pattern(glob)
	local parts = {}
	local i = 1
	local len = #glob
	while i <= len do
		local c = glob:sub(i, i)
		if c == "*" and glob:sub(i + 1, i + 1) == "*" then
			parts[#parts + 1] = ".*"
			i = i + 2
			if glob:sub(i, i) == "/" then
				i = i + 1
			end
		elseif c == "*" then
			parts[#parts + 1] = "[^/]*"
			i = i + 1
		elseif c == "?" then
			parts[#parts + 1] = "[^/]"
			i = i + 1
		elseif c == "[" then
			local j = glob:find("]", i + 1)
			if j then
				parts[#parts + 1] = glob:sub(i, j)
				i = j + 1
			else
				parts[#parts + 1] = "%["
				i = i + 1
			end
		elseif lua_special[c] then
			parts[#parts + 1] = "%" .. c
			i = i + 1
		else
			parts[#parts + 1] = c
			i = i + 1
		end
	end
	return table.concat(parts)
end

--- Read .gitignore from `cwd` and return a list of parsed patterns.
--- Each entry: { lua_pattern, negated, dir_only, anchored }
local function parse_gitignore(cwd)
	local path = cwd .. "/.gitignore"
	local f = io.open(path, "r")
	if not f then
		return {}
	end
	local patterns = {}
	for line in f:lines() do
		line = line:match("^(.-)%s*$") or line
		if line == "" or line:sub(1, 1) == "#" then
			goto continue
		end
		local negated = false
		if line:sub(1, 1) == "!" then
			negated = true
			line = line:sub(2)
		end
		local dir_only = false
		if line:sub(-1) == "/" then
			dir_only = true
			line = line:sub(1, -2)
		end
		-- Leading **/ matches at any depth (same as unanchored)
		while line:sub(1, 3) == "**/" do
			line = line:sub(4)
		end
		-- A slash anywhere in the pattern anchors it relative to cwd
		local anchored = line:find("/") ~= nil
		if line:sub(1, 1) == "/" then
			line = line:sub(2)
		end
		patterns[#patterns + 1] = {
			lua_pattern = glob_to_lua_pattern(line),
			negated = negated,
			dir_only = dir_only,
			anchored = anchored,
		}
		::continue::
	end
	f:close()
	return patterns
end

--- Check whether `rel_path` (relative to cwd) should be ignored.
--- Last matching pattern wins; negated patterns re-include.
local function is_ignored(rel_path, is_dir, patterns)
	local basename = rel_path:match("[^/]+$")
	local ignored = false
	for _, p in ipairs(patterns) do
		if p.dir_only and not is_dir then
			goto continue
		end
		local matched
		if p.anchored then
			matched = rel_path:match("^" .. p.lua_pattern .. "$") ~= nil
		else
			matched = basename:match("^" .. p.lua_pattern .. "$") ~= nil
		end
		if matched then
			ignored = not p.negated
		end
		::continue::
	end
	return ignored
end

local function collect_files(dir, cwd, results, patterns)
	local handle = vim.uv.fs_scandir(dir)
	if not handle then
		return
	end
	while true do
		local name, typ = vim.uv.fs_scandir_next(handle)
		if not name then
			break
		end
		-- skip hidden files/dirs
		if name:sub(1, 1) == "." then
			goto continue
		end
		local full = dir .. "/" .. name
		local rel = full:sub(#cwd + 2) -- strip cwd + trailing /
		if typ == "directory" then
			if not is_ignored(rel, true, patterns) then
				collect_files(full, cwd, results, patterns)
			end
		else
			if not is_ignored(rel, false, patterns) then
				results[#results + 1] = rel
			end
		end
		::continue::
	end
end

function source:complete(params, callback)
	local cwd = vim.fn.getcwd()
	local gitignore_patterns = parse_gitignore(cwd)
	local files = {}
	collect_files(cwd, cwd, files, gitignore_patterns)

	local cursor = params.context.cursor
	local line = params.context.cursor_before_line
	local at_pos = line:find("@[^%s]*$")
	if not at_pos then
		callback({})
		return
	end

	local start_char = at_pos - 1 -- 0-indexed for LSP range

	local items = {}
	for _, rel in ipairs(files) do
		items[#items + 1] = {
			label = "@" .. rel,
			sortText = rel,
			filterText = "@" .. rel,
			textEdit = {
				newText = "@" .. rel,
				range = {
					start = { line = cursor.line, character = start_char },
					["end"] = { line = cursor.line, character = cursor.character },
				},
			},
		}
	end

	callback(items)
end

return source
