if vim.g.vscode then
	return
end

whenOk(require, "telescope", function(telescope)
	telescope.setup({
		defaults = {
			path_display = { "truncate" },
		},
	})
end)

keymap.set("n", "<C-p>", function()
	require("telescope.builtin").git_files()
end)
