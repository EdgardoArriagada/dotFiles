return {
	{ "github/copilot.vim" },
	{ "windwp/nvim-ts-autotag", dependencies = { "nvim-treesitter/nvim-treesitter" } },
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		keys = "<C-p>",
	},
	{ "moll/vim-bbye" },
	-- if it doesn't work, follow https://github.com/ekickx/clipboard-image.nvim/issues/50
	{ "ekickx/clipboard-image.nvim", ft = { "markdown" } },
}
