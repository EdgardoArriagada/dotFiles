function OpenBufferInNewTmuxWindow(opts)
	vim.fn.system("tmux new-window nvim " .. vim.fn.expand("%:p"))
	if opts ~= "NoClose" then
		vim.cmd("q!")
	end
end

function FullGitSplit()
	vim.cmd("Gvdiffsplit!")
	OpenBufferInNewTmuxWindow()
end

function Cppath()
	local repoName = EscapePattern(FromShell("get_repo_name"))
	local path = vim.fn.expand("%:p")

	local result = path:gsub("^.*" .. repoName .. "/", ""):gsub("^%./", "")

	vim.fn.setreg("+", result)
	print(result .. " Copied!")
end
