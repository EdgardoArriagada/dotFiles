
local function mappings(api, opts)
	local closeNodeWith = MakeMultimap("n", api.node.navigate.parent_close, opts("Close Directory"))
	local editNodeWith = MakeMultimap("n", api.node.open.edit, opts("Open Directory"))

	closeNodeWith({ "<BS>", "h" })

	editNodeWith({ "l", "<CR>", "o" })

	kset("n", "s", api.node.open.vertical, opts("Open file"))
	kset("n", "i", api.node.open.horizontal, opts("Open file horizontally"))
	kset("n", "y", api.fs.copy.node, opts("Copy"))
	kset("n", "x", api.fs.cut, opts("Cut"))
	kset("n", "p", api.fs.paste, opts("Paste"))
end

local function on_attach(bufnr)
	local ok, api = pcall(require, "nvim-tree.api")
	if not ok then
		return
	end

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	mappings(api, opts)
end

return {
	"kyazdani42/nvim-tree.lua",
	dependencies = { "kyazdani42/nvim-web-devicons" },
	tag = "nightly", -- optional, updated every week. (see issue #1193)
	cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeClose", "NvimTreeRefresh", "NvimTreeFindFile" },
	config = function()
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
			on_attach = on_attach,
			renderer = {
				root_folder_modifier = ":t",
				highlight_git = true,
				icons = {
					glyphs = {
						default = "",
						symlink = "",
						git = {
							unstaged = "●",
							staged = "●",
							unmerged = "",
							renamed = "➜",
							deleted = "",
							untracked = "⁇",
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
				hide_root_folder = false,
				side = "left",
				number = false,
				relativenumber = false,
			},
			actions = {
				open_file = {
					resize_window = true,
					quit_on_open = false,
					window_picker = {
						enable = false,
					},
				},
			},
		})
	end,
}
