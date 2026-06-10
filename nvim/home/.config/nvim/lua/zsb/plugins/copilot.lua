return {
	"zbirenbaum/copilot.lua",
	event = "InsertEnter",
	cmd = "Copilot",
	config = function()
		require("copilot").setup({
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = true,
				debounce = 75,
				keymap = {
					accept = "<C-x>",
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
}
