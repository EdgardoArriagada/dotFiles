return {
	"christoomey/vim-tmux-navigator",
	config = function()
		kset("n", "C-h", ":TmuxNavigateLeft<CR>")
		kset("n", "C-j", ":TmuxNavigateDown<CR>")
		kset("n", "C-k", ":TmuxNavigateUp<CR>")
		kset("n", "C-l", ":TmuxNavigateRight<CR>")
	end,
}
