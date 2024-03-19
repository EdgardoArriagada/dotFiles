return {
	{
		event = "InsertEnter",
		"github/copilot.vim",
	},
	{
		event = "InsertEnter",
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		keys = { "<leader>", "<C-p>" },
	},
	{ "moll/vim-bbye" },
	-- if it doesn't work, follow https://github.com/ekickx/clipboard-image.nvim/issues/50
	{ "ekickx/clipboard-image.nvim", ft = { "markdown" } },
}
