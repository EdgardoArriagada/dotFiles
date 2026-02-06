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

local skip_dirs = {
	[".git"] = true,
	["node_modules"] = true,
	["build"] = true,
	["dist"] = true,
	[".next"] = true,
}

local function collect_files(dir, cwd, results)
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
		if typ == "directory" then
			if not skip_dirs[name] then
				collect_files(full, cwd, results)
			end
		else
			local rel = full:sub(#cwd + 2) -- strip cwd + trailing /
			results[#results + 1] = rel
		end
		::continue::
	end
end

function source:complete(params, callback)
	local cwd = vim.fn.getcwd()
	local files = {}
	collect_files(cwd, cwd, files)

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
