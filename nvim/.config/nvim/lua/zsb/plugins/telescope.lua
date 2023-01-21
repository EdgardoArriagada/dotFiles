return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim" },
	opts = {
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
	},
	keys = function()
		keymap.set("n", "<C-p>", function()
			require("telescope.builtin").git_files({
				show_untracked = true,
			})
		end)
	end,
}
