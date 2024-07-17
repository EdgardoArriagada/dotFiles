return {
	"christoomey/vim-tmux-navigator",
	keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
	config = function()
		local opts = { silent = true }

		kset("n", "C-h", ":TmuxNavigateLeft<CR>", opts)
		kset("n", "C-j", ":TmuxNavigateDown<CR>", opts)
		kset("n", "C-k", ":TmuxNavigateUp<CR>", opts)
		kset("n", "C-l", ":TmuxNavigateRight<CR>", opts)
	end,
}
