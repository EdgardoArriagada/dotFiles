return {
	"stevearc/oil.nvim",
	dependencies = { "kyazdani42/nvim-web-devicons" },
	keys = { "-" },
	config = Config("oil", function(oil)
		oil.setup()
		kset("n", "-", oil.open, { noremap = true })
	end),
}
