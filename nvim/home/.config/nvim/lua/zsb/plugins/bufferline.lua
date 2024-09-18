return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "famiu/bufdelete.nvim" },
	config = Config("bufferline", function(bufferline)
		bufferline.setup()

		Kset("n", "Q", function()
			require("bufdelete").bufdelete(0, true)
		end)

		Kset("n", "<C-n>", function()
			bufferline.cycle(1)
		end)

		Kset("n", "<C-b>", function()
			bufferline.cycle(-1)
		end)
	end),
}
