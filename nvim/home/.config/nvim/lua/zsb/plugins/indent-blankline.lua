return {
	"lukas-reineke/indent-blankline.nvim",
	event = "VeryLazy",
	main = "ibl",
	config = Config("ibl", function(ibl)
		local hooks = require("ibl.hooks")

		local palette = require("nordic.colors")

		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "RainbowViolet", { fg = palette.magenta.dim })
		end)

		ibl.setup({
			indent = { char = "│" },
			whitespace = {
				remove_blankline_trail = false,
			},
			scope = { enabled = true, highlight = "RainbowViolet" },
		})
	end),
}
