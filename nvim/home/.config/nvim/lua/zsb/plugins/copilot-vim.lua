return {
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
			},
		})
	end,
}
