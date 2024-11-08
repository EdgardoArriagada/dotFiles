Cautocmd("VimEnter", {
	callback = function()
		if vim.g.zsb_prevent_renametab == 1 then
			return
		end

		local win_id = vim.fn.system("tmux display-message -p '#{window_id}'"):gsub("%s+", "")

		SetTimeout(function()
			local currentFile = vim.fn.expand("%:p")
			vim.fn.system("zsb_charm_tmux_renametab " .. win_id .. " " .. currentFile)
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
