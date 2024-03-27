return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = Config("bufferline", function(bufferline)
		bufferline.setup()

		kset("n", "Q", ":Bdelete<Cr>")
		kset("n", "<C-n>", ":BufferLineCycleNext<Cr>")
		kset("n", "<C-b>", ":BufferLineCyclePrev<Cr>")
	end),
}
