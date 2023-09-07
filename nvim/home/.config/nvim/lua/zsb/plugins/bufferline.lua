return {
	"akinsho/bufferline.nvim",
	dependencies = { "kyazdani42/nvim-web-devicons" },
	config = function()
		Hpcall(require, "bufferline", {
			onOk = function(bufferline)
				bufferline.setup()
			end,
			onErr = "failed to setup bufferline",
		})

		kset("n", "Q", ":Bdelete<Cr>")
		kset("n", "<C-l>", ":BufferLineCycleNext<Cr>")
		kset("n", "<C-h>", ":BufferLineCyclePrev<Cr>")
	end,
}
