local function Cond()
	local ft = vim.bo.filetype

	return ft ~= "alpha" and ft ~= "NvimTree"
end

local FILENAME = {
	{
		"filetype",
		cond = Cond,
		icon_only = true,
	},
	{
		"filename",
		cond = Cond,
		path = 1,
		file_status = false,
		shorting_target = 0,
		symbols = {
			modified = "",
			readonly = "",
			unnamed = "",
			newfile = "",
		},
	},
}

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
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
			lualine_x = { "searchcount", "encoding", "fileformat", "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		inactive_sections = {}, -- not seen with globalstatus = true
		tabline = {}, -- clashes with nvim-bufferline
		winbar = {
			lualine_c = FILENAME,
		},
		inactive_winbar = {
			lualine_c = FILENAME,
		},
		extensions = {},
	},
}
