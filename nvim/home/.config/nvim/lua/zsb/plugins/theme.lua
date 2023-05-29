return {
	"eddyekofo94/gruvbox-flat.nvim",
	config = function(conf)
		-- Change here --
		---------- -------- -------- --------
		local theme = "gruvbox-flat"
		vim.g.gruvbox_flat_style = "dark"

		-- more color strings at https://github.com/eddyekofo94/gruvbox-flat.nvim/blob/master/lua/gruvbox/colors.lua
		-- more keys to override at https://github.com/eddyekofo94/gruvbox-flat.nvim/blob/master/lua/gruvbox/theme.lua
		local borderTheme = { fg = "tree_normal", bg = "bg" }
		vim.g.gruvbox_theme = {
			NormalFloat = { bg = "#303030" },
			Identifier = { fg = "blue" },
			Function = { fg = "yellow" },
			-- Telescope
			TelescopePreviewBorder = borderTheme,
			TelescopePreviewTitle = borderTheme,
			TelescopePromptBorder = borderTheme,
			TelescopePromptTitle = borderTheme,
			TelescopeResultsBorder = borderTheme,
			TelescopeResultsTitle = borderTheme,
		}

		---------- -------- -------- --------

		local colorCmd = "colorscheme " .. theme

		hpcall(vim.cmd, colorCmd, {
			onErr = function()
				vim.notify(colorCmd .. " not found!")
				vim.cmd([[colorscheme default]])
			end,
		})
	end,
}
