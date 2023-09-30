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
