Cautocmd("VimEnter", {
	callback = function()
		SetTimeout(function()
			vim.fn.system('tmux rename-window "  $(get_repo_name)"')
		end, 0)
	end,
})

Cautocmd("VimLeave", {
	callback = function()
		vim.fn.system("tmux set automatic-rename")
	end,
})
