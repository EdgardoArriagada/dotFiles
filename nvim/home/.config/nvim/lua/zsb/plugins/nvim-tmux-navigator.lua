return {
	"christoomey/vim-tmux-navigator",
	keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
	config = function()
		kset("n", "C-h", ":TmuxNavigateLeft<CR>")
		kset("n", "C-j", ":TmuxNavigateDown<CR>")
		kset("n", "C-k", ":TmuxNavigateUp<CR>")
		kset("n", "C-l", ":TmuxNavigateRight<CR>")
	end,
}
