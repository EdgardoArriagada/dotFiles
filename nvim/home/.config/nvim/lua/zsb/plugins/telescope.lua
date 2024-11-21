return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim" },
		keys = { "<C-p>" },
		cmd = "Telescope",
		config = Config("telescope", function(telescope)
			local function sendToQflist(bufnr)
				require("telescope.actions").send_to_qflist(bufnr)
				Exec("copen")
			end

			telescope.setup({
				defaults = {
					path_display = { "truncate" },
					mappings = {
						i = {
							["<C-u>"] = { "<c-s-u>", type = "command" },
							["<C-q>"] = require("telescope.actions").close,
							["<C-t>"] = sendToQflist,
						},
						n = {
							["q"] = require("telescope.actions").close,
							["<C-q>"] = require("telescope.actions").close,
							["<C-t>"] = sendToQflist,
						},
					},
					vimgrep_arguments = {
						-- default (search for vimgrep_arguments in https://github.com/nvim-telescope/telescope.nvim)
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						-- config
						"-g=!package-lock.json",
					},
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

			Kset("n", "<C-p>", function()
				require("telescope.builtin").git_files({
					show_untracked = true,
				})
			end)

			telescope.load_extension("fzf")
		end),
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		lazy = true,
		build = "make",
	},
}
