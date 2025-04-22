return {
	"AlexvZyl/nordic.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("nordic").load({
			on_highlight = function(highlights, palette)
				-- https://neovim.io/doc/user/syntax.html
				-- https://github.com/AlexvZyl/nordic.nvim/blob/main/lua/nordic/colors/nordic.lua
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
					bold = true,
				}
				highlights.ColorColumn = {
					bg = palette.gray1,
					bold = true,
				}
				highlights.Delimiter = {
					fg = palette.white0_normal,
					bold = false,
				}
				highlights.PmenuSel = { bg = palette.gray3 }
			end,
		})
	end,
}
