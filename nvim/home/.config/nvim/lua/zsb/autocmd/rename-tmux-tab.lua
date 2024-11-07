Cautocmd("VimEnter", {
	callback = function()
		if vim.g.zsb_prevent_renametab == 1 then
			return
		end

		local win_id = vim.fn.system("tmux display-message -p '#{window_id}'"):gsub("%s+", "")

		SetTimeout(function()
			vim.fn.system("tmux rename-window -t " .. win_id .. ' " $(get_repo_name)"')
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
