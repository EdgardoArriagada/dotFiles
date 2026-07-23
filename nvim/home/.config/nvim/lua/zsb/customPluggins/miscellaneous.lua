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
	local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
	vim.api.nvim_feedkeys("ciw" .. replacement .. esc, "n", true)
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
