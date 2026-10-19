return {
	"iamcco/markdown-preview.nvim",
	build = ":call mkdp#util#install_sync()",
	config = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	ft = { "markdown" },
}
