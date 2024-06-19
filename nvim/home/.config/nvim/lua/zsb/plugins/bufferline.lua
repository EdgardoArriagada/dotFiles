return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "famiu/bufdelete.nvim" },
	config = Config("bufferline", function(bufferline)
		bufferline.setup()

		kset("n", "Q", function()
			require("bufdelete").bufdelete(0, true)
		end)

		kset("n", "<C-n>", function()
			bufferline.cycle(1)
		end)

		kset("n", "<C-b>", function()
			bufferline.cycle(-1)
		end)
	end),
}
