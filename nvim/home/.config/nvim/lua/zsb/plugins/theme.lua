return {
	"AlexvZyl/nordic.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local nordic = require("nordic")
		local palette = require("nordic.colors")

		nordic.setup({
			override = {
				Visual = {
					bg = palette.gray3,
					bold = false,
				},
			},
		})

		nordic.load()
	end,
}
