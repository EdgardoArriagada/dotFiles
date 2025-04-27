function HasBufCorrectSize(buf)
	local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))

	if not ok or not stats then
		return false
	end

	return stats.size < 100 * 1024 -- 100 KB
end

function GetDirectionalProps(direction)
	if direction == "j" then
		return 1, vim.fn.line("$")
	elseif direction == "k" then
		return -1, 1
	end
end

function StartsWith(beginning, input)
	return string.find(input, "^" .. beginning)
end

function IsEmptyString(input)
	return input:find("^%s*$")
end

function IsEmptyLine(lnum)
	return IsEmptyString(GetLineContent(lnum))
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
	local lnum = GetCurrentLNum()
	-- Go to beggin of line and add to jump list
	Exec("normal" .. lnum .. "G^")

	local lineMarker = GetFirstNoEmptyLine(direction, lnum)

	Exec("normal" .. GetSameIndentLin(direction, lineMarker) .. "G^")
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

function EscapePattern(text)
	return text:gsub("([^%w])", "%%%1")
end

function MakeMultimap(mode, action, opts)
	return function(keys)
		for _, key in ipairs(keys) do
			Kset(mode, key, action, opts)
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
	local startVisualPos = vim.fn.getpos("v")[3]

	return string.sub(vim.api.nvim_get_current_line(), startVisualPos, GetCurrentCol())
end

--- @class OpenFileInPositionArgs
--- @field filename string: The filename
--- @field lnum number: The line number
--- @field col number: The column number

--- @return nil
--- @param args OpenFileInPositionArgs
function OpenFileInPosition(args)
	local current_filename = vim.fn.expand("%:p")
	local input_filename = vim.fn.fnamemodify(args.filename, ":p")

	if current_filename == input_filename then
		-- Add to jumplist
		Exec("norm! m'")
	else
		-- Edit that file
		Exec("e " .. args.filename)
	end

	vim.api.nvim_win_set_cursor(0, { args.lnum, args.col - 1 })
end

function ShowMenu(conf, opts)
	local height = conf.height or 20
	local width = conf.width or 60
	local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

	local winId = require("plenary.popup").create(opts or {}, {
		title = conf.title,
		line = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = height,
		borderchars = borderchars,
		callback = conf.callback,
	})

	function CloseMenu()
		vim.api.nvim_win_close(winId, true)
	end

	local bufnr = vim.api.nvim_win_get_buf(winId)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua CloseMenu()<CR>", { silent = false })
end

function SetTimeout(callback, timeout)
	local timer = vim.uv.new_timer()
	if not timer then
		return
	end
	timer:start(timeout, 0, function()
		timer:stop()
		timer:close()
		vim.schedule_wrap(callback)()
	end)
	return timer
end

function SetInterval(callback, timeout)
	local timer = vim.uv.new_timer()
	if not timer then
		return
	end
	timer:start(timeout, timeout, vim.schedule_wrap(callback))
	return timer
end

function ClearInterval(timer)
	timer:stop()
	timer:close()
end

function GetIndent(lnum)
	return #GetLineContent(lnum):match("^%s*")
end
