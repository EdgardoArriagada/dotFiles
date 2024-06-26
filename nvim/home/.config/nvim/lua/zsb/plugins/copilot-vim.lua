return {
	event = "InsertEnter",
	"github/copilot.vim",
	config = function()
		vim.g.copilot_no_tab_map = true
		vim.g.copilot_filetypes = { TelescopePrompt = false, harpoon = false }

		kset("i", "<C-l>", "copilot#Accept()", { expr = true, silent = true, replace_keycodes = false })
		kset("i", "<C-_>", "copilot#Dismiss()", { expr = true, silent = true })
		kset("n", "<C-_>", "copilot#Dismiss()", { expr = true, silent = true })
	end,
}
