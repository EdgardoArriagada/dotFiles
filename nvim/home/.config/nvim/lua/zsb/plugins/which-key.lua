return {
	"max397574/which-key.nvim",
	keys = { "<leader>", { "<leader>", mode = "v" } },
	config = function()
		local status_ok, which_key = pcall(require, "which-key")
		if not status_ok then
			return
		end

		local setup = {
			plugins = {
				marks = true, -- shows a list of your marks on ' and `
				registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
				spelling = {
					enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
					suggestions = 20, -- how many suggestions should be shown in the list?
				},
				-- the presets plugin, adds help for a bunch of default keybindings in Neovim
				-- No actual key bindings are created
				presets = {
					operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
					motions = false, -- adds help for motions
					text_objects = false, -- help for text objects triggered after entering an operator
					windows = true, -- default bindings on <c-w>
					nav = true, -- misc bindings to work with windows
					z = true, -- bindings for folds, spelling and others prefixed with z
					g = true, -- bindings for prefixed with g
				},
			},
			-- add operators that will trigger motion and text object completion
			-- to enable all native operators, set the preset / operators plugin above
			-- operators = { gc = "Comments" },
			key_labels = {
				-- override the label used to display some keys. It doesn't effect WK in any other way.
				-- For example:
				-- ["<space>"] = "SPC",
				-- ["<cr>"] = "RET",
				-- ["<tab>"] = "TAB",
			},
			icons = {
				breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
				separator = "➜", -- symbol used between a key and it's label
				group = "+", -- symbol prepended to a group
			},
			popup_mappings = {
				scroll_down = "<c-d>", -- binding to scroll down inside the popup
				scroll_up = "<c-u>", -- binding to scroll up inside the popup
			},
			window = {
				border = "rounded", -- none, single, double, shadow
				position = "bottom", -- bottom, top
				margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
				padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
				winblend = 0,
			},
			layout = {
				height = { min = 4, max = 25 }, -- min and max height of the columns
				width = { min = 20, max = 50 }, -- min and max width of the columns
				spacing = 3, -- spacing between columns
				align = "left", -- align columns left, center or right
			},
			ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
			hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
			show_help = true, -- show help message on the command line when the popup is visible
			triggers = "auto", -- automatically setup triggers
			-- triggers = {"<leader>"} -- or specify a list manually
			triggers_blacklist = {
				-- list of mode / prefixes that should never be hooked by WhichKey
				-- this is mostly relevant for key maps that start with a native binding
				-- most people should not need to change this
				i = { "j", "k" },
				v = { "j", "k" },
			},
		}

		local opts = {
			mode = "n", -- NORMAL mode
			prefix = "<leader>",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = true, -- use `nowait` when creating keymaps
		}

		local mappings = {
			["/"] = { '<cmd>lua require("Comment.api").toggle_current_linewise()<CR>', "Comment" },
			["a"] = { "<cmd>Alpha<cr>", "Alpha" },
			["x"] = { "<cmd>lua Logger()<cr>", "JS Log" },
			["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
			["w"] = { "<cmd>w!<CR>", "Save" },
			["q"] = { "<cmd>q!<CR>", "Quit" },
			["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
			["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
			["t"] = { "<cmd>TransparentToggle<cr>", "Transparency" },
			["f"] = {
				"<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
				"Find files",
			},
			["F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
			["P"] = { "<cmd>Telescope projects<cr>", "Projects" },
			n = {
				name = "NvimTree",
				t = { "<cmd>NvimTreeToggle<cr>", "Toggle" },
				r = { "<cmd>NvimTreeRefresh<cr>", "Refresh" },
			},
			g = {
				name = "Git",
				n = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
				p = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
				b = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
				v = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
				r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
				s = { "<cmd>Gvdiffsplit!<cr>", "Fugitive Split" },
				S = { "<cmd>lua FullGitSplit()<cr>", "Fugitive custom split" },
				h = { "<cmd>diffget //2<cr>", "Pick left" },
				l = { "<cmd>diffget //3<cr>", "Pick right" },
				R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
				P = { "<cmd>lua ViewPrOfLine()<cr>", "View pr of line" },
				a = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Add Hunk" },
				u = {
					"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
					"Undo Stage Hunk",
				},
				o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
				d = {
					"<cmd>Gitsigns diffthis HEAD<cr>",
					"Diff",
				},
			},
			l = {
				name = "LSP",
				a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
				d = {
					"<cmd>Telescope lsp_document_diagnostics<cr>",
					"Document Diagnostics",
				},
				w = {
					"<cmd>Telescope lsp_workspace_diagnostics<cr>",
					"Workspace Diagnostics",
				},
				f = { "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Format" },
				i = { "<cmd>LspInfo<cr>", "Info" },
				I = { "<cmd>Mason<cr>", "Info" },
				n = {
					"<cmd>lua vim.diagnostic.goto_next()<CR>",
					"Next Diagnostic",
				},
				p = {
					"<cmd>lua vim.diagnostic.goto_prev()<cr>",
					"Prev Diagnostic",
				},
				l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
				q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
				r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
				s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
				S = {
					"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
					"Workspace Symbols",
				},
			},
			v = {
				name = "Vim",
				t = { "<cmd>lua ToggleJsFile()<cr>", "Toggle js file" },
			},
			s = {
				name = "Search",
				t = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
				d = { "<cmd>Telescope lsp_references<cr>", "References" },
				b = { "<cmd>Telescope file_browser<cr>", "Checkout branch" },
				c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
				h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
				M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
				r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
				R = { "<cmd>Telescope registers<cr>", "Registers" },
				k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
				C = { "<cmd>Telescope commands<cr>", "Commands" },
			},
			-- https://github.com/folke/lazy.nvim#-usage
			p = {
				name = "Plugins",
				l = { "<cmd>Lazy<cr>", "Plugins list" },
				s = { "<cmd>Lazy sync<cr>", "Plugins sync" },
				h = { "<cmd>Lazy health<cr>", "Plugins health" },
			},
			b = {
				name = "Buffer",
				y = {
					"<cmd>lua Cppath()<cr>",
					"Copy File Path",
				},
				a = {
					"<cmd>lua require('harpoon.mark').add_file()<cr>",
					"Harpoon add file",
				},
				o = {
					"<cmd>BufferLineCloseLeft<cr>|<cmd>BufferLineCloseRight<cr>",
					"Buffer Only",
				},
				["!"] = {
					"<cmd>lua OpenBufferInNewTmuxWindow()<cr>",
					"Move buffer to new tmux window",
				},
				c = {
					"<cmd>lua OpenBufferInNewTmuxWindow('NoClose')<cr>",
					"Copy buffer to new tmux window",
				},
				t = {
					"<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>",
					"Harpoon add file",
				},
				n = {
					"<cmd>lua require('harpoon.ui').nav_next()<cr>",
					"Harpoon Next",
				},
				p = {
					"<cmd>lua require('harpoon.ui').nav_prev()<cr>",
					"Harpoon Prev",
				},
				z = {
					"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
					"Buffers",
				},
			},
			m = {
				name = "Markdown",
				p = {
					"<cmd>MarkdownPreviewToggle<cr>",
					"Preview Toggle",
				},
				i = {
					"<cmd>PasteImg<cr>",
					"Paste Image",
				},
			},
			r = {
				name = "Refactor",
				b = {
					"<Cmd>lua require('refactoring').refactor('Extract Block')<CR>",
					"Extract Block",
				},
				bf = {
					"<Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>",
					"Extract Block To File",
				},
				i = {
					"<Cmd>lua require('refactoring').refactor('Inline Variable')<CR>",
					"Inline Variable",
				},
			},
		}

		local vopts = {
			mode = "v", -- VISUAL mode
			prefix = "<leader>",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = true, -- use `nowait` when creating keymaps
		}

		local vmappings = {
			["/"] = { '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>', "Comment" },
			r = {
				name = "Refactor",
				e = {
					"<Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>",
					"Extract Function",
				},
				f = {
					"<Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>",
					"Extract Function To File",
				},
				v = {
					"<Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>",
					"Extract Variable",
				},
				i = {
					"<Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>",
					"Inline Variable",
				},
				r = {
					name = "React",
					e = {
						"<Cmd>lua require('react-extract').extract_to_current_file()<CR>",
						"Extract Component",
					},
					f = {
						"<Cmd>lua require('react-extract').extract_to_new_file()<CR>",
						"Extract Component to New File",
					},
				},
			},
		}

		which_key.setup(setup)
		which_key.register(mappings, opts)
		which_key.register(vmappings, vopts)
	end,
}
