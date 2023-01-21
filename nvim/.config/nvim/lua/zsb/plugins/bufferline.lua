return {
	"akinsho/bufferline.nvim",
	config = function()
		hpcall(require, "bufferline", {
			onOk = function(bufferline)
				bufferline.setup()
			end,
			onErr = "failed to setup bufferline",
		})

		keymap.set("n", "Q", ":Bdelete<Cr>")
		keymap.set("n", "<S-l>", ":BufferLineCycleNext<Cr>")
		keymap.set("n", "<S-h>", ":BufferLineCyclePrev<Cr>")
	end,
}
