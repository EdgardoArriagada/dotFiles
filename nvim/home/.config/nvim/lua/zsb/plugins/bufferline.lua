return {
	"akinsho/bufferline.nvim",
	dependencies = { "kyazdani42/nvim-web-devicons" },
	config = function()
		hpcall(require, "bufferline", {
			onOk = function(bufferline)
				bufferline.setup()
			end,
			onErr = "failed to setup bufferline",
		})

		keymap.set("n", "Q", ":Bdelete<Cr>")
		keymap.set("n", "<C-l>", ":BufferLineCycleNext<Cr>")
		keymap.set("n", "<C-h>", ":BufferLineCyclePrev<Cr>")
	end,
}
