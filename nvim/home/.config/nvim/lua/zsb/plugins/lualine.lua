local blink = false

local function getDirname(path)
	local dirname = path:match("^(.*)/[^/]+$")

	if dirname == nil then
		return "."
	end

	return dirname
end

local function macroRecordingComponent(props)
	return {
		"macro-recording",
		icon = { color = props.iconColor },
		fmt = function(_, ctx)
			local recording_register = vim.fn.reg_recording()

			if recording_register == "" then
				return ""
			else
				if blink then
					ctx.options.icon = { " " }
				else
					ctx.options.icon = { "" }
				end

				return " @" .. recording_register
			end
		end,
	}
end

local function dirnameComponent(props)
	return {
		"filename",
		fmt = getDirname,
		icon = { " ", color = props.folderColor },
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
	return {
		"filetype",
		icon_only = true,
		color = props.textColor,
		colored = props.ftIconColored or false,
	}
end

local function filenameComponent(props)
	return {
		"filename",
		file_status = false,
		color = props.textColor,
	}
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local palette = require("nordic.colors")
		local lualine = require("lualine")

		local FOCUS_PROPS = { textColor = { bg = palette.black1, gui = "bold" } }
		local BLUR_PROPS = { textColor = { fg = palette.gray3, gui = "italic" } }

		-- Make refresh statusline more resoponsive
		local group = CreateAugroup("Zsb_lualine")
		local function refreshStatusline()
			lualine.refresh({
				place = { "statusline" },
			})
		end

		local timer

		Cautocmd("RecordingEnter", {
			callback = function()
				refreshStatusline()
				timer = SetInterval(function()
					blink = not blink
					refreshStatusline()
				end, 600)
			end,
			group = group,
		})

		Cautocmd("RecordingLeave", {
			callback = function()
				ClearInterval(timer)
				blink = false -- ensure icon always starts visible
				SetTimeout(refreshStatusline, 50)
			end,
			group = group,
		})
		-- end

		lualine.setup({
			options = {
				icons_enabled = true,
				theme = "nordic",
				component_separators = { left = "", right = "" },
				section_separators = { left = " ", right = " " },
				disabled_filetypes = {
					statusline = {},
					winbar = { "alpha", "NvimTree", "Avante", "AvanteInput", "qf", "dbui", "oil", "noice" },
				},
				always_divide_middle = true,
				globalstatus = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
					"diff",
					"diagnostics",
					macroRecordingComponent({
						iconColor = { fg = palette.red.dim },
					}),
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
					dirnameComponent(Extend(FOCUS_PROPS, {
						folderColor = { fg = palette.yellow.dim },
					})),
					fileIconComponent(Extend(FOCUS_PROPS, {
						ftIconColored = true,
					})),
					filenameComponent(FOCUS_PROPS),
				},
			},
			inactive_winbar = {
				lualine_c = {
					dirnameComponent(BLUR_PROPS),
					fileIconComponent(BLUR_PROPS),
					filenameComponent(BLUR_PROPS),
				},
			},
			extensions = {},
		})
	end,
}
