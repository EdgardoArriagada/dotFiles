return {
	{
		event = "InsertEnter",
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	-- if it doesn't work, follow https://github.com/ekickx/clipboard-image.nvim/issues/50
	{ "ekickx/clipboard-image.nvim", ft = { "markdown" } },
}
