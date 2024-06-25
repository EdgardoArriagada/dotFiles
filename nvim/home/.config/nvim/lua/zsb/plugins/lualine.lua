local function isNonSpecialFt()
	local ft = vim.bo.filetype

	return ft ~= "alpha" and ft ~= "NvimTree" and ft ~= "TelescopePrompt"
end

local function getDirname(path)
	local dirname = path:match("^(.*)/[^/]+$")

	if dirname == nil then
		return "."
	end

	return dirname
end

local function getDirnameComponent(opts)
	local dirname = {
		"filename",
		fmt = getDirname,
		icon = " ",
		cond = isNonSpecialFt,
		path = 1,
		file_status = false,
		shorting_target = 0,
		symbols = {
			modified = "",
			readonly = "",
			unnamed = "",
			newfile = "",
		},
	}

	local icon = { "filetype", icon_only = true, cond = isNonSpecialFt }
	local filename = { "filename", file_status = false, cond = isNonSpecialFt }

	if opts ~= nil and opts.color then
		dirname.color = opts.color
		icon.color = opts.color
		filename.color = opts.color
	end

	return { dirname, icon, filename }
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local palette = require("nordic.colors")

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "nordic",
				component_separators = { left = "", right = "" },
				section_separators = { left = " ", right = " " },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				always_divide_middle = true,
				globalstatus = true,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = {},
				lualine_x = { "searchcount", "encoding", "fileformat" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {}, -- not seen with globalstatus = true
			tabline = {}, -- clashes with nvim-bufferline
			winbar = {
				lualine_c = getDirnameComponent({
					color = { bg = palette.black1, gui = "bold" },
				}),
			},
			inactive_winbar = {
				lualine_c = getDirnameComponent({
					color = { fg = palette.gray3, gui = "italic" },
				}),
			},
			extensions = {},
		})
	end,
}
