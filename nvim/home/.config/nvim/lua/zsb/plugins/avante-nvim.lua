return {
	"yetone/avante.nvim",
	cmd = { "AvanteAsk", "AvanteToggle" },
	version = false, -- set this if you want to always pull the latest change
	opts = {
		-- add any opts here
	},
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = "make",
	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	dependencies = {
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		{
			event = "InsertEnter",
			cmd = "Copilot",
			"zbirenbaum/copilot.lua",
			config = function()
				require("copilot").setup({
					suggestion = {
						enabled = true,
						auto_trigger = true,
						hide_during_completion = true,
						debounce = 75,
						keymap = {
							accept = "<C-l>",
							accept_word = false,
							accept_line = false,
							next = "<M-]>",
							prev = "<M-[>",
							dismiss = "<C-_>",
						},
					},
					filetypes = {
						TelescopePrompt = false,
						harpoon = false,
						NvimTree = false,
						dbui = false,
						qf = false,
						hgcommit = false,
						gitrebase = false,
						gitcommit = false,
						help = false,
						alpha = false,
						oil = false,
						["."] = false,
					},
				})

				Kset("n", "<C-_>", require("copilot.suggestion").dismiss)
			end,
		}, -- for providers='copilot'
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
