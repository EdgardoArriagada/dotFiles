return {
	"AlexvZyl/nordic.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local nordic = require("nordic")
		-- https://github.com/AlexvZyl/nordic.nvim/blob/main/lua/nordic/colors/nordic.lua
		local palette = require("nordic.colors")

		nordic.setup({
			-- https://neovim.io/doc/user/syntax.html
			override = {
				Visual = {
					bg = palette.gray2,
					bold = false,
				},
				Search = {
					bg = palette.gray1,
					fg = palette.white0_normal,
					bold = false,
					underline = false,
				},
				IncSearch = {
					bg = palette.gray3,
					fg = palette.white1,
					bold = true,
					underline = true,
				},
				CursorLine = {
					bg = palette.gray1,
					bold = true, -- Or false.
				},
				ColorColumn = {
					bg = palette.gray1,
					bold = true, -- Or false.
				},
				Delimiter = {
					fg = palette.white0_normal,
					bold = false,
				},
				PmenuSel = { bg = palette.gray3 },
			},
		})

		nordic.load({})
	end,
}
