return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = Config("which-key", function(wk)
		wk.add({
			{ "<leader>a", "<cmd>Alpha<cr>", desc = "Alpha" },
			{ "<leader>x", Logger, desc = "Logger", mode = { "n", "v" } },
			{ "<leader>X", LoggerSP, desc = "LoggerSp", mode = { "n", "v" } },
			{ "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
			{
				"<leader>t",
				function()
					require("transparent").toggle()
				end,
				desc = "Transparency",
			},
			{
				"<leader>f",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Find files",
			},
			{ "<leader>F", "<cmd>Telescope live_grep theme=ivy<cr>", desc = "Find Text" },
			{ "<leader>P", PasteToQf, desc = "Paste to qf" },
			{ "<leader>nr", "<cmd>NvimTreeRefresh<cr>", desc = "Toggle" },
			{
				"<leader>df",
				function()
					require("refactoring").debug.printf({ below = true })
				end,
				desc = "Function",
			},
			{
				"<leader>dc",
				function()
					require("refactoring").debug.cleanup({})
				end,
				desc = "Cleanup",
			},
			{ "<leader>gn", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", desc = "Next Hunk" },
			{ "<leader>gp", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", desc = "Prev Hunk" },
			{ "<leader>gb", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Blame" },
			{ "<leader>gv", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk" },
			{ "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk" },
			{ "<leader>gs", "<cmd>Gvdiffsplit!<cr>", desc = "Fugitive Split" },
			{ "<leader>gS", FullGitSplit, desc = "Fugitive custom split" },
			{ "<leader>gh", "<cmd>diffget //2<cr>", desc = "Pick left" },
			{ "<leader>gl", "<cmd>diffget //3<cr>", desc = "Pick right" },
			{ "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer" },
			{ "<leader>gP", "<cmd>lua ViewPrOfLine()<cr>", desc = "View pr of line" },
			{ "<leader>ga", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", desc = "Add Hunk" },
			{ "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk" },
			{ "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Open changed file" },
			{ "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff" },
			{ "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
			{ "<leader>ld", "<cmd>Telescope lsp_document_diagnostics<cr>", desc = "Document Diagnostics" },
			{ "<leader>lw", "<cmd>Telescope lsp_workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
			{ "<leader>lf", "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", desc = "Format" },
			{
				"<leader>lh",
				function()
					if vim.lsp.inlay_hint.is_enabled() then
						vim.lsp.inlay_hint.enable(false)
					else
						vim.lsp.inlay_hint.enable()
					end
				end,
				desc = "Toggle inlay hints",
			},
			{ "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
			{ "<leader>lI", "<cmd>Mason<cr>", desc = "Info" },
			{ "<leader>lN", vim.diagnostic.goto_next, desc = "Next Diagnostic" },
			{ "<leader>lP", vim.diagnostic.goto_prev, desc = "Prev Diagnostic" },
			{
				"<leader>ln",
				function()
					vim.diagnostic.goto_next({
						severity = vim.diagnostic.severity.ERROR,
					})
				end,
				desc = "Next Error",
			},
			{
				"<leader>lp",
				function()
					vim.diagnostic.goto_prev({
						severity = vim.diagnostic.severity.ERROR,
					})
				end,
				desc = "Prev Error",
			},
			{ "<leader>ll", vim.lsp.codelens.run, desc = "CodeLens Action" },
			{ "<leader>lq", vim.diagnostic.setloclist, desc = "Quickfix" },
			{ "<leader>lr", vim.lsp.buf.rename, desc = "Rename" },
			{ "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
			{ "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
			{ "<leader>vt", TestToggler, desc = "Toggle to test file" },
			{ "<leader>vd", "<cmd>tab DBUI<cr>", desc = "View database client" },
			{ "<leader>va", "<cmd>AvanteToggle<cr>", desc = "Toggle avante chat" },
			{ "<leader>vq", ToggleQf, desc = "Toggle qf list" },
			{ "<leader>rb", "<cmd>tab DBUI<cr>", desc = "View database client" },
			{ "<leader>ra", "<cmd>AvanteToggle<cr>", desc = "Toggle avante chat" },
			{ "<leader>rq", ToggleQf, desc = "Toggle qf list" },
			{ "<leader>rb", "<cmd>tab DBUI<cr>", desc = "View database client" },
			{ "<leader>ra", "<cmd>AvanteToggle<cr>", desc = "Toggle avante chat" },
			{ "<leader>rq", ToggleQf, desc = "Toggle qf list" },
			{ "<leader>rb", "<cmd>tab DBUI<cr>", desc = "View database client" },
			{ "<leader>ra", "<cmd>AvanteToggle<cr>", desc = "Toggle avante chat" },
			{ "<leader>rq", ToggleQf, desc = "Toggle qf list" },
			{ "<leader>rb", "<cmd>tab DBUI<cr>", desc = "View database client" },
			{ "<leader>ra", "<cmd>AvanteToggle<cr>", desc = "Toggle avante chat" },
			{ "<leader>rq", ToggleQf, desc = "Toggle qf list" },
			{ "<leader>rb", "<cmd>tab DBUI<cr>", desc = "View database client" },
			{ "<leader>ra", "<cmd>AvanteToggle<cr>", desc = "Toggle avante chat" },
			{ "<leader>rq", ToggleQf, desc = "Toggle qf list" },
			{ "<leader>st", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
			{
				"<leader>sn",
				function()
					require("telescope.builtin").live_grep({
						vimgrep_arguments = {
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
				desc = "snt",
			},
			{ "<leader>sr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
			{ "<leader>sb", "<cmd>Telescope file_browser<cr>", desc = "Checkout branch" },
			{ "<leader>sc", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
			{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Find Help" },
			{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man pages" },
			{ "<leader>so", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },
			{ "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers" },
			{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
			{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{ "<leader>l", "<cmd>Lazy<cr>", desc = "Plugins list" },
			{ "<leader>ls", "<cmd>Lazy sync<cr>", desc = "Plugins sync" },
			{ "<leader>lh", "<cmd>Lazy health<cr>", desc = "Plugins health" },
			{ "<leader>by", Cppath, desc = "Copy File Path" },
			{
				"<leader>ba",
				function()
					require("harpoon.mark").add_file()
				end,
				desc = "Harpoon add file",
			},
			{
				"<leader>bo",
				function()
					require("bufferline").close_others()
				end,
				desc = "Buffer Only",
			},
			{ "<leader>b!", OpenBufferInNewTmuxWindow, desc = "Move buffer to new tmux window" },
			{
				"<leader>bc",
				function()
					OpenBufferInNewTmuxWindow("NoClose")
				end,
				desc = "Copy buffer to new tmux window",
			},
			{
				"<leader>bt",
				function()
					require("harpoon.ui").toggle_quick_menu()
				end,
				desc = "Harpoon toogle quick menu",
			},
			{
				"<leader>bn",
				function()
					require("harpoon.ui").nav_next()
				end,
				desc = "Harpoon Next",
			},
			{
				"<leader>bp",
				function()
					require("harpoon.ui").nav_prev()
				end,
				desc = "Harpoon Prev",
			},
			{ "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Preview Toggle" },
			{ "<leader>mi", "<cmd>PasteImg<cr>", desc = "Paste Image" },
			{
				"<leader>rb",
				function()
					require("refactoring").refactor("Extract Block")
				end,
				desc = "Extract Block",
			},
			{
				"<leader>rbf",
				function()
					require("refactoring").refactor("Extract Block To File")
				end,
				desc = "Extract Block To File",
			},
			{
				"<leader>ri",
				function()
					require("refactoring").refactor("Inline Variable")
				end,
				desc = "Inline Variable",
			},
			-- complete translating vmappings
			{
				"<leader>rf",
				function()
					require("refactoring").refactor("Extract Function")
				end,
				desc = "Extract Function",
				mode = "v",
			},
			{
				"<leader>re",
				function()
					require("refactoring").refactor("Extract Function To File")
				end,
				desc = "Extract Function To File",
				mode = "v",
			},
			{
				"<leader>rv",
				function()
					require("refactoring").refactor("Extract Variable")
				end,
				desc = "Extract Variable",
				mode = "v",
			},
			{
				"<leader>ri",
				function()
					require("refactoring").refactor("Inline Variable")
				end,
				desc = "Inline Variable",
				mode = "v",
			},
			{
				"<leader>rre",
				function()
					require("react-extract").extract_to_current_file()
				end,
				desc = "Extract React Component",
				mode = "v",
			},
			{
				"<leader>rrf",
				function()
					require("react-extract").extract_to_new_file()
				end,
				desc = "Extract React Component to New File",
				mode = "v",
			},
		})
	end),
}
