local theme = "dashboard"

return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local alpha = require("alpha")
		local current_theme = require("alpha.themes." .. theme)

		local banner = {
			"                                                                   ",
			"      ████ ██████           █████      ██                    ",
			"     ███████████             █████                            ",
			"     █████████ ███████████████████ ███   ███████████  ",
			"    █████████  ███    █████████████ █████ ██████████████  ",
			"   █████████ ██████████ █████████ █████ █████ ████ █████  ",
			" ███████████ ███    ███ █████████ █████ █████ ████ █████ ",
			"██████  █████████████████████ ████ █████ █████ ████ ██████",
		}

		local padding = math.floor(vim.api.nvim_win_get_height(0) / 10)

		for _ = 1, padding do
			table.insert(banner, 1, "")
			table.insert(banner, "")
		end

		current_theme.section.header.val = banner

		alpha.setup(current_theme.opts)
	end,
}
