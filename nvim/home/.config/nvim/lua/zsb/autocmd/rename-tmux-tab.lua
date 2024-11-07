Cautocmd("VimEnter", {
	callback = function()
		if vim.g.zsb_prevent_renametab == 1 then
			return
		end

		SetTimeout(function()
			vim.fn.system('tmux rename-window "  $(get_repo_name)"')
		end, 600)
	end,
	group = Group,
})

Cautocmd("VimLeave", {
	callback = function()
		if vim.g.zsb_prevent_renametab == 1 then
			return
		end

		vim.fn.system("tmux set automatic-rename")
	end,
})
