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
	{ "mg979/vim-visual-multi" },
	{ "github/copilot.vim" },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "windwp/nvim-ts-autotag", dependencies = { "nvim-treesitter/nvim-treesitter" } },
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", keys = "<C-p>" },
	{ "moll/vim-bbye" },
	{ "ekickx/clipboard-image.nvim", ft = { "markdown" } },
}
