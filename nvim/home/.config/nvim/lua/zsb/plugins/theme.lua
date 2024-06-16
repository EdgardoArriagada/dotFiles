return {
	"AlexvZyl/nordic.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local nordic = require("nordic")
		-- https://github.com/AlexvZyl/nordic.nvim/blob/main/lua/nordic/colors/nordic.lua
		local palette = require("nordic.colors")

		nordic.setup({
			-- https://neovim.io/doc/user/syntax.html#group-name
			override = {
				Visual = {
					bg = palette.gray2,
					bold = false,
				},
				Delimiter = {
					fg = palette.white0_normal,
					bold = false,
				},
			},
		})

		nordic.load()
	end,
}
