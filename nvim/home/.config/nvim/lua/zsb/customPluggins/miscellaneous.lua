function OpenBufferInNewTmuxWindow(opts)
	vim.system({ "tmux", "new-window", "nvim", vim.fn.expand("%:p") })
	if opts ~= "NoClose" then
		Exec("q!")
	end
end

function FullGitSplit()
	Exec("Gvdiffsplit!")
	OpenBufferInNewTmuxWindow()
end

function Cppath()
	local repoRoot = EscapePattern(vim.system({ "git", "rev-parse", "--show-toplevel" }):wait().stdout:gsub("\n", ""))
	local path = vim.fn.expand("%:p")

	local result = path:gsub(repoRoot .. "/", "")

	vim.fn.setreg("+", result)
	vim.notify(result .. " Copied!")
end

function CppathHome()
	local home = EscapePattern(vim.env.HOME)
	local path = vim.fn.expand("%:p")

	local result = path:gsub("^" .. home, "~")

	vim.fn.setreg("+", result)
	vim.notify(result .. " Copied!")
end

function ToggleSetWrap()
	vim.wo.wrap = not vim.wo.wrap
end

function ToggleRelativeNumber()
	vim.wo.relativenumber = not vim.wo.relativenumber
end

function ToggleBool()
	local word = vim.fn.expand("<cword>")
	local map = {
		["true"] = "false", ["false"] = "true",
		["True"] = "False", ["False"] = "True",
		["TRUE"] = "FALSE", ["FALSE"] = "TRUE",
	}
	local replacement = map[word]
	if not replacement then return end

	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	local cursor_lua = col + 1
	local search_from = 1

	while true do
		local s, e = line:find(word, search_from, true)
		if not s then return end
		if s <= cursor_lua and cursor_lua <= e then
			vim.api.nvim_buf_set_text(0, row - 1, s - 1, row - 1, e, { replacement })
			return
		end
		search_from = e + 1
	end
end

-- returns the content of the given line number
--- @param lnum number: The line number
function GetLineContent(lnum)
	return vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, true)[1]
end

function GetCurrentLNum()
	return vim.api.nvim_win_get_cursor(0)[1]
end

function GetCurrentCol()
	return vim.api.nvim_win_get_cursor(0)[2] + 1
end
