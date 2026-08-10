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

local function make_relative(from_dir, abs_path)
	local function split(p)
		local parts = {}
		for s in p:gmatch("[^/]+") do parts[#parts + 1] = s end
		return parts
	end
	local f = split(from_dir)
	local t = split(abs_path)
	local i = 1
	while i <= #f and i <= #t and f[i] == t[i] do i = i + 1 end
	local rel = {}
	for _ = i, #f do rel[#rel + 1] = ".." end
	for j = i, #t do rel[#rel + 1] = t[j] end
	return table.concat(rel, "/")
end

local function make_items(files, cursor, start_char)
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
	return items
end

function source:complete(params, callback)
	local cwd = vim.fn.getcwd()
	local cursor = params.context.cursor
	local line = params.context.cursor_before_line
	local at_pos = line:find("@[^%s]*$")
	if not at_pos then
		callback({})
		return
	end
	local start_char = at_pos - 1

	local finish = function(files)
		vim.schedule(function() callback(make_items(files, cursor, start_char)) end)
	end

	local parse_lines = function(stdout, transform)
		local files = {}
		for f in stdout:gmatch("[^\n]+") do
			files[#files + 1] = transform and transform(f) or f
		end
		return files
	end

	vim.system(
		{ "git", "rev-parse", "--show-toplevel" },
		{ cwd = cwd, text = true },
		function(root_result)
			if root_result.code == 0 then
				local root = root_result.stdout:gsub("%s+$", "")
				vim.system(
					{ "git", "ls-files", "--cached", "--others", "--exclude-standard" },
					{ cwd = root, text = true },
					function(result)
						finish(
							(result.code == 0 and result.stdout)
							and parse_lines(result.stdout, function(f) return make_relative(cwd, root .. "/" .. f) end)
							or {}
						)
					end
				)
			else
				-- not a git repo: try fd, fall back to find
				vim.system(
					{ "fd", "--type", "f", "--strip-cwd-prefix" },
					{ cwd = cwd, text = true },
					function(fd_result)
						if fd_result.code == 0 and fd_result.stdout and fd_result.stdout ~= "" then
							finish(parse_lines(fd_result.stdout))
						else
							vim.system(
								{ "find", ".", "-type", "f", "-not", "-path", "*/.git/*" },
								{ cwd = cwd, text = true },
								function(find_result)
									finish(
										(find_result.code == 0 and find_result.stdout)
										and parse_lines(find_result.stdout, function(f) return f:gsub("^%./", "") end)
										or {}
									)
								end
							)
						end
					end
				)
			end
		end
	)
end

return source
