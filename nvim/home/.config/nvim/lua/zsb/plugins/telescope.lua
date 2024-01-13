return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim" },
	keys = { "<leader>", "<C-p>" },
	config = Config("telescope", function(telescope)
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

		kset("n", "<C-p>", function()
			require("telescope.builtin").git_files({
				show_untracked = true,
			})
		end)

		telescope.load_extension("fzf")
	end),
}
