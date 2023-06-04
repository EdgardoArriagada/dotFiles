-- if it doesnt install, you can manually do so
-- cd ~/.local/share/nvim/lazy/markdown-preview.nvim && npm install
return {
	"iamcco/markdown-preview.nvim",
	build = "cd app && npm install",
	config = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	ft = { "markdown" },
}
