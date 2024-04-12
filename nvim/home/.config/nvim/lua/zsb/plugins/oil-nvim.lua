return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = { "#" },
	config = Config("oil", function(oil)
		oil.setup()
		kset("n", "#", oil.open, { noremap = true })
	end),
}
