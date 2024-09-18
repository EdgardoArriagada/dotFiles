local function isNonSpecialFt()
	local ft = vim.bo.filetype

	return ft ~= "alpha" and ft ~= "NvimTree"
end

local function getDirname(path)
	local dirname = path:match("^(.*)/[^/]+$")

	if dirname == nil then
		return "."
	end

	return dirname
end

local function macroRecordingComponent()
	return {
		"macro-recording",
		fmt = function()
			local recording_register = vim.fn.reg_recording()
			if recording_register == "" then
				return ""
			else
				return "  @" .. recording_register
			end
		end,
	}
end

local function basenameComponent(props)
	return { -- Dirname
		"filename",
		fmt = getDirname,
		icon = { " ", color = props.folderColor },
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
		color = props.textColor,
	}
end

local function fileIconComponent(props)
	return { -- Icon
		"filetype",
		icon_only = true,
		cond = isNonSpecialFt,
		color = props.textColor,
		colored = props.ftIconColored or false,
	}
end

local function filenameComponent(props)
	return { -- Filename
		"filename",
		file_status = false,
		cond = isNonSpecialFt,
		color = props.textColor,
	}
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local palette = require("nordic.colors")

		local FOCUS_COLOR = { bg = palette.black1, gui = "bold" }
		local BLUR_COLOR = { fg = palette.gray3, gui = "italic" }

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "nordic",
				component_separators = { left = "", right = "" },
				section_separators = { left = " ", right = " " },
				disabled_filetypes = {
					statusline = {},
					winbar = { "alpha", "NvimTree", "Avante", "AvanteInput", "qf", "dbui", "oil" },
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
				lualine_b = {
					"branch",
					"diff",
					"diagnostics",
					macroRecordingComponent(),
				},
				lualine_c = {},
				lualine_x = { "searchcount", "encoding", "fileformat" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {}, -- not seen with globalstatus = true
			tabline = {}, -- clashes with nvim-bufferline
			winbar = {
				lualine_c = {
					basenameComponent({
						textColor = FOCUS_COLOR,
						folderColor = { fg = palette.yellow.dim },
					}),
					fileIconComponent({
						textColor = FOCUS_COLOR,
						ftIconColored = true,
					}),
					filenameComponent({
						textColor = FOCUS_COLOR,
					}),
				},
			},
			inactive_winbar = {
				lualine_c = {
					basenameComponent({
						textColor = BLUR_COLOR,
					}),
					fileIconComponent({
						textColor = BLUR_COLOR,
					}),
					filenameComponent({
						textColor = BLUR_COLOR,
					}),
				},
			},
			extensions = {},
		})
	end,
}
