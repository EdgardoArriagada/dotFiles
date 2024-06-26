return {
	event = "InsertEnter",
	"github/copilot.vim",
	config = function()
		vim.g.copilot_no_tab_map = true
		vim.cmd([[imap <silent><script><expr> <C-l> copilot#Accept("\<CR>")]])
		vim.cmd([[imap <silent><script><expr> <C-_> copilot#Dismiss()]])
		vim.cmd([[nmap <silent><script><expr> <C-_> copilot#Dismiss()]])
		vim.g.copilot_filetypes = { TelescopePrompt = false, harpoon = false }
	end,
}
