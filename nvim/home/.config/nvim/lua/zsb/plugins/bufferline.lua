return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "famiu/bufdelete.nvim" },
	config = Config("bufferline", function(bufferline)
		bufferline.setup()

		kset("n", "Q", function()
			require("bufdelete").bufdelete(0, true)
		end)

		kset("n", "<C-n>", ":BufferLineCycleNext<Cr>")
		kset("n", "<C-b>", ":BufferLineCyclePrev<Cr>")
	end),
}
