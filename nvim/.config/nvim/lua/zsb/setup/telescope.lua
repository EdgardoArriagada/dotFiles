if vim.g.vscode then
	return
end

hpcall(require, "telescope", {
	onOk = function(telescope)
		telescope.setup({
			defaults = {
				path_display = { "truncate" },
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})

		telescope.load_extension("fzf")
	end,
	onErr = "failed to setup telescope",
})

keymap.set("n", "<C-p>", function()
	require("telescope.builtin").git_files()
end)
