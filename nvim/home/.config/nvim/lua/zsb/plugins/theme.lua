return {
	"AlexvZyl/nordic.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local nordic = require("nordic")

		nordic.setup({
			-- https://neovim.io/doc/user/syntax.html
			-- https://github.com/AlexvZyl/nordic.nvim/blob/main/lua/nordic/colors/nordic.lua
			on_highlight = function(highlights, palette)
				highlights.Visual = {
					bg = palette.gray2,
					bold = false,
				}
				highlights.Search = {
					bg = palette.gray1,
					fg = palette.white0_normal,
					bold = false,
					underline = false,
				}
				highlights.IncSearch = {
					bg = palette.gray3,
					fg = palette.white1,
					bold = true,
					underline = true,
				}
				highlights.CursorLine = {
					bg = palette.gray1,
					bold = true, -- Or false.
				}
				highlights.ColorColumn = {
					bg = palette.gray1,
					bold = true, -- Or false.
				}
				highlights.Delimiter = {
					fg = palette.white0_normal,
					bold = false,
				}
				highlights.PmenuSel = { bg = palette.gray3 }
			end,
		})

		nordic.load({})
	end,
}
