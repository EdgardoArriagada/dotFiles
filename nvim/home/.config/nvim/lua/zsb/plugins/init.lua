return {
	-- completion plugins
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lua" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-cmdline" },
	{ "hrsh7th/nvim-cmp" },
	{ "saadparwaiz1/cmp_luasnip" }, -- snippet completions
	-- end completion
	{ "github/copilot.vim" },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
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
