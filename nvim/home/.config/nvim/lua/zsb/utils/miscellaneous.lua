function HasBufCorrectSize(buf)
	local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))

	if not ok or not stats then
		return false
	end

	return stats.size < 100 * 1024 -- 100 KB
end

function GetDirectionalProps(direction)
	if direction == "j" then
		return 1, line("$")
	elseif direction == "k" then
		return -1, 1
	end
end

function StartsWith(beginning, input)
	return string.match(input, "^" .. beginning) ~= nil
end

function IsEmptyString(input)
	return input:match("^%s*$") ~= nil
end

function IsEmptyLine(line)
	return IsEmptyString(vim.fn.getline(line))
end

function GetFirstNoEmptyLine(direction, lineMarker)
	local inc, endOfFile = GetDirectionalProps(direction)
	while lineMarker ~= endOfFile do
		if not IsEmptyLine(lineMarker) then
			return lineMarker
		end

		lineMarker = lineMarker + inc
	end
	return lineMarker
end

function LookForIndentation(direction)
	-- Go to beggin of line and add to jump list
	Execute("normal" .. line(".") .. "G^")

	local lineMarker = GetFirstNoEmptyLine(direction, line("."))

	Execute("normal" .. getSameIndentLine(direction, lineMarker) .. "G^")
end

function ArrayElement(t)
	local i = 0

	return function()
		i = i + 1
		return t[i]
	end
end

function ArrayElementBackward(t)
	local i = #t + 1

	return function()
		i = i - 1
		return t[i]
	end
end

function ToupleArrayElement(t)
	local i = 0

	return function()
		i = i + 1
		if t[i] then
			return t[i][1], t[i][2]
		end
	end
end

function FromShell(command)
	local handle = io.popen(command)

	if handle then
		local result = handle:read("*a")
		handle:close()
		return result
	end

	return nil
end

function EscapePattern(text)
	return text:gsub("([^%w])", "%%%1")
end

function MakeMultimap(mode, action, opts)
	return function(keys)
		for _, key in ipairs(keys) do
			kset(mode, key, action, opts)
		end
	end
end

function IsCurrentLineFolded()
	return vim.fn.foldclosed(".") ~= -1
end

-- usefull alias to print anythin even tables
function P(input)
	print(vim.inspect(input))
end

function GetVisualSelection()
	local currPos = vim.fn.col(".")
	local startVisualPos = vim.fn.getpos("v")[3]

	return string.sub(vim.api.nvim_get_current_line(), startVisualPos, currPos)
end

local function is_file_opened(filename)
	-- Normalize the path for the given filename
	local normalized_filename = vim.fn.fnamemodify(filename, ":p")

	-- Iterate over all buffers
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) then
			-- Get the full path of the file associated with the buffer
			local buf_name = vim.api.nvim_buf_get_name(buf)
			local normalized_buf_name = vim.fn.fnamemodify(buf_name, ":p")

			-- Compare the normalized paths
			if normalized_buf_name == normalized_filename then
				return true
			end
		end
	end
	return false
end

function OpenFileInPosition(file_name, line, col)
	if is_file_opened(file_name) then
		-- Add to jumplist
		Execute("norm! m'")
		-- Open the file in the current buffer
		vim.api.nvim_set_current_buf(vim.fn.bufnr(file_name))
	else
		-- Open the file in a new tab
		vim.api.nvim_command("tabedit " .. file_name)
	end

	vim.api.nvim_win_set_cursor(0, { line, col - 1 })
end
