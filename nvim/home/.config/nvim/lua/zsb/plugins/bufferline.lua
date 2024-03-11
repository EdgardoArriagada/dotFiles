return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = Config("bufferline", function(bufferline)
		bufferline.setup()

		kset("n", "Q", ":Bdelete<Cr>")
		kset("n", "<C-l>", ":BufferLineCycleNext<Cr>")
		kset("n", "<C-h>", ":BufferLineCyclePrev<Cr>")
	end),
}
