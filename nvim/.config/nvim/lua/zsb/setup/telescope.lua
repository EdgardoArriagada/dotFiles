if vim.g.vscode then
	return
end

hpcall(require, "telescope", {
	onOk = function(telescope)
		telescope.setup({
			defaults = {
				path_display = { "truncate" },
			},
		})
	end,
	onErr = "failed to setup telescope",
})

keymap.set("n", "<C-p>", function()
	require("telescope.builtin").git_files()
end)
