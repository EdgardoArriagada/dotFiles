--[[ if vim.g.vscode then return end ]]
-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
	return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

-- https://www.nerdfonts.com/cheat-sheet
nvim_tree.setup({
	renderer = {
		root_folder_modifier = ":t",
		highlight_git = true,
		icons = {
			glyphs = {
				default = "",
				symlink = "",
				git = {
					unstaged = "",
					staged = "",
					unmerged = "",
					renamed = "➜",
					deleted = "",
					untracked = "U",
					ignored = "◌",
				},
				folder = {
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
				},
			},
			show = {
				git = true,
				folder = true,
				file = true,
				folder_arrow = true,
			},
		},
	},
	disable_netrw = true,
	hijack_netrw = true,
	open_on_setup = false,
	ignore_ft_on_setup = {
		"startify",
		"dashboard",
		"alpha",
	},
	open_on_tab = false,
	hijack_cursor = false,
	update_cwd = true,
	hijack_directories = {
		enable = true,
		auto_open = true,
	},
	diagnostics = {
		enable = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	update_focused_file = {
		enable = true,
		update_cwd = true,
		ignore_list = {},
	},
	git = {
		enable = true,
		ignore = true,
		timeout = 500,
	},
	view = {
		width = 30,
		height = 30,
		hide_root_folder = false,
		side = "left",
		mappings = {
			custom_only = false,
			-- for full list of actions:
			-- https://github.com/kyazdani42/nvim-tree.lua/blob/master/lua/nvim-tree/actions/dispatch.lua
			list = {
				{ key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
				{ key = "h", cb = tree_cb("close_node") },
				{ key = "s", cb = tree_cb("vsplit") },
				{ key = "i", cb = tree_cb("split") },
				{ key = "y", cb = tree_cb("copy") },
				{ key = "x", cb = tree_cb("cut") },
				{ key = "p", cb = tree_cb("paste") },
			},
		},
		number = false,
		relativenumber = false,
	},
	actions = {
		open_file = {
			resize_window = true,
			quit_on_open = false,
			window_picker = {
				enable = true,
			},
		},
	},
})
