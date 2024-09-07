return {
	"folke/which-key.nvim",
	keys = { "<leader>", { "<leader>", mode = "v" } },
	config = Config("which-key", function(which_key)
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
			["a"] = { "<cmd>Alpha<cr>", "Alpha" },
			["x"] = { Logger, "Logger" },
			["X"] = { LoggerSP, "LoggerSp" },
			["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
			["t"] = {
				function()
					require("transparent").toggle()
				end,
				"Transparency",
			},
			["f"] = {
				function()
					require("telescope.builtin").find_files(
						require("telescope.themes").get_dropdown({ previewer = false })
					)
				end,
				"Find files",
			},
			["F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
			["P"] = { PasteToQf, "Paste to qf" },
			n = {
				name = "NvimTree",
				t = { "<cmd>NvimTreeToggle<cr>", "Toggle" },
				r = { "<cmd>NvimTreeRefresh<cr>", "Refresh" },
			},
			d = {
				name = "Debug",
				f = {
					function()
						require("refactoring").debug.printf({ below = true })
					end,
					"Function",
				},
				c = {
					function()
						require("refactoring").debug.cleanup({})
					end,
					"Cleanup",
				},
			},
			g = {
				name = "Git",
				n = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
				p = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
				b = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
				v = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
				r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
				s = { "<cmd>Gvdiffsplit!<cr>", "Fugitive Split" },
				S = { FullGitSplit, "Fugitive custom split" },
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
				h = {
					function()
						if vim.lsp.inlay_hint.is_enabled() then
							vim.lsp.inlay_hint.enable(false)
						else
							vim.lsp.inlay_hint.enable()
						end
					end,
					"Toggle inlay hints",
				},
				i = { "<cmd>LspInfo<cr>", "Info" },
				I = { "<cmd>Mason<cr>", "Info" },
				N = {
					vim.diagnostic.goto_next,
					"Next Diagnostic",
				},
				P = {
					vim.diagnostic.goto_prev,
					"Prev Diagnostic",
				},
				n = {
					function()
						vim.diagnostic.goto_next({
							severity = vim.diagnostic.severity.ERROR,
						})
					end,
					"Next Error",
				},
				p = {
					function()
						vim.diagnostic.goto_prev({
							severity = vim.diagnostic.severity.ERROR,
						})
					end,
					"Prev Error",
				},
				l = { vim.lsp.codelens.run, "CodeLens Action" },
				q = { vim.diagnostic.setloclist, "Quickfix" },
				r = { vim.lsp.buf.rename, "Rename" },
				s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
				S = {
					"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
					"Workspace Symbols",
				},
			},
			v = {
				name = "view",
				t = { TestToggler, "Toggle to test file" },
				d = { "<cmd>tab DBUI<cr>", "View database client" },
				a = { "<cmd>AvanteToggle<cr>", "toggle avante chat" },
			},
			s = {
				name = "Search",
				t = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
				n = {
					function()
						require("telescope.builtin").live_grep({
							vimgrep_arguments = {
								-- default (search for vimgrep_arguments in https://github.com/nvim-telescope/telescope.nvim)
								"rg",
								"--color=never",
								"--no-heading",
								"--with-filename",
								"--line-number",
								"--column",
								"--smart-case",
								-- config
								"-g=!package-lock.json",
								-- this
								"-g=!*__tests__*",
								"-g=!*__test__*",
								"-g=!*Test.java",
								"-g=!*mocks*",
								"-g=!*fixtures*",
							},
						})
					end,
					"snt",
				},
				r = { "<cmd>Telescope lsp_references<cr>", "References" },
				b = { "<cmd>Telescope file_browser<cr>", "Checkout branch" },
				c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
				h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
				M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
				o = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
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
					Cppath,
					"Copy File Path",
				},
				a = {
					function()
						require("harpoon.mark").add_file()
					end,
					"Harpoon add file",
				},
				o = {
					function()
						require("bufferline").close_others()
					end,
					"Buffer Only",
				},
				["!"] = {
					OpenBufferInNewTmuxWindow,
					"Move buffer to new tmux window",
				},
				c = {
					function()
						OpenBufferInNewTmuxWindow("NoClose")
					end,
					"Copy buffer to new tmux window",
				},
				t = {
					function()
						require("harpoon.ui").toggle_quick_menu()
					end,
					"Harpoon toogle quick menu",
				},
				n = {
					function()
						require("harpoon.ui").nav_next()
					end,
					"Harpoon Next",
				},
				p = {
					function()
						require("harpoon.ui").nav_prev()
					end,
					"Harpoon Prev",
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
					function()
						require("refactoring").refactor("Extract Block")
					end,
					"Extract Block",
				},
				bf = {
					function()
						require("refactoring").refactor("Extract Block To File")
					end,
					"Extract Block To File",
				},
				i = {
					function()
						require("refactoring").refactor("Inline Variable")
					end,
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
			["x"] = {
				Logger,
				"Logger",
			},
			["X"] = {
				LoggerSP,
				"LoggerSP",
			},
			r = {
				name = "Refactor",
				f = {
					function()
						require("refactoring").refactor("Extract Function")
					end,
					"Extract Function",
				},
				e = {
					function()
						require("refactoring").refactor("Extract Function To File")
					end,
					"Extract Function To File",
				},
				v = {
					function()
						require("refactoring").refactor("Extract Variable")
					end,
					"Extract Variable",
				},
				i = {
					function()
						require("refactoring").refactor("Inline Variable")
					end,
					"Inline Variable",
				},
				r = {
					name = "React",
					e = {
						function()
							require("react-extract").extract_to_current_file()
						end,
						"Extract Component",
					},
					f = {
						function()
							require("react-extract").extract_to_new_file()
						end,
						"Extract Component to New File",
					},
				},
			},
		}

		which_key.setup(setup)
		which_key.register(mappings, opts)
		which_key.register(vmappings, vopts)
	end),
}
