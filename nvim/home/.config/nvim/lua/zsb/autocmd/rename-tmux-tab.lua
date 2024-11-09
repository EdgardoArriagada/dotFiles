Cautocmd("VimEnter", {
	callback = function()
		if vim.g.zsb_prevent_renametab == 1 then
			return
		end

		local currentFile = vim.api.nvim_buf_get_name(0)

		vim.system({ "tmux", "display-message", "-p", "#{window_id}" }, {
			stdout = function(_, winId)
				vim.system({ "zsb_charm_tmux_renametab", winId:gsub("\n", ""), currentFile })
			end,
		})
	end,
	group = Group,
})

Cautocmd("VimLeave", {
	callback = function()
		if vim.g.zsb_prevent_renametab == 1 then
			return
		end

		vim.system({ "tmux", "set", "automatic-rename" })
	end,
})
