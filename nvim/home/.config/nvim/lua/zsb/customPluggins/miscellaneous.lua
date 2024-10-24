function OpenBufferInNewTmuxWindow(opts)
	vim.fn.system("tmux new-window nvim " .. vim.fn.expand("%:p"))
	if opts ~= "NoClose" then
		Exec("q!")
	end
end

function FullGitSplit()
	Exec("Gvdiffsplit!")
	OpenBufferInNewTmuxWindow()
end

function Cppath()
	local repoName = EscapePattern(FromShell("get_repo_name"))
	local path = vim.fn.expand("%:p")

	local result = path:gsub("^.*" .. repoName .. "/", ""):gsub("^%./", "")

	vim.fn.setreg("+", result)
	vim.notify(result .. " Copied!")
end

function ToggleSetWrap()
	vim.wo.wrap = not vim.wo.wrap
end

function ToggleRelativeNumber()
	vim.wo.relativenumber = not vim.wo.relativenumber
end
