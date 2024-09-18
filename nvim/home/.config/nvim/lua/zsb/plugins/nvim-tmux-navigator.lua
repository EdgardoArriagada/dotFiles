return {
	"christoomey/vim-tmux-navigator",
	keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
	config = function()
		local opts = { silent = true }

		Kset("n", "C-h", ":TmuxNavigateLeft<CR>", opts)
		Kset("n", "C-j", ":TmuxNavigateDown<CR>", opts)
		Kset("n", "C-k", ":TmuxNavigateUp<CR>", opts)
		Kset("n", "C-l", ":TmuxNavigateRight<CR>", opts)
	end,
}
