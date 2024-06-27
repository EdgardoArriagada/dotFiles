return {
	"kyazdani42/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	tag = "nightly", -- optional, updated every week. (see issue #1193)
	cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeClose", "NvimTreeRefresh", "NvimTreeFindFile" },
	config = Config("nvim-tree", function(nvim_tree)
		local function mappings(api, opts)
			local closeNodeWith = MakeMultimap("n", api.node.navigate.parent_close, opts("Close Directory"))
			local editNodeWith = MakeMultimap("n", api.node.open.edit, opts("Open Directory"))

			closeNodeWith({ "<BS>", "h" })

			editNodeWith({ "l", "<CR>", "o" })

			kset("n", "v", api.node.open.vertical, opts("Open file vertically"))
			kset("n", "s", api.node.open.horizontal, opts("Open file horizontally"))
			kset("n", "y", api.fs.copy.node, opts("Copy"))
			kset("n", "Y", api.fs.copy.filename, opts("Copy filename"))
			kset("n", "x", api.fs.cut, opts("Cut"))
			kset("n", "p", api.fs.paste, opts("Paste"))
			kset("n", "K", api.node.show_info_popup, opts("Info"))
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

		-- https://www.nerdfonts.com/cheat-sheet
		nvim_tree.setup({
			on_attach = on_attach,
			renderer = {
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
						file = true,
						folder = true,
						folder_arrow = true,
						git = true,
					},
				},
			},
			disable_netrw = true,
			hijack_netrw = true,
			hijack_cursor = false,
			sync_root_with_cwd = true,
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
				update_root = true,
			},
			git = {
				enable = true,
				timeout = 500,
			},
			view = {
				width = {}, -- a table makes it adaptive
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
	end),
}
