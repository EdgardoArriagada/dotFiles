local FORWARD = 1
local BACKWARD = -1

local function jump(a)
	return function()
		vim.diagnostic.jump({ count = a.direction, float = true, severity = a.severity })
	end
end

local function paste_prompt(prompt)
	return function()
		vim.api.nvim_put(vim.split(prompt.get(), "\n"), "l", true, true)
	end
end

local function prompt_with_desc(key, prompt)
	return { key, paste_prompt(prompt), desc = prompt.desc }
end

local function paste_link()
	local link = vim.fn.getreg("+"):gsub("%s+$", "")
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))

	vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { "[](" .. link .. ")" })
	vim.api.nvim_win_set_cursor(0, { row, col + 1 })
	vim.cmd("startinsert")
end

local function toggle_strikethrough()
	local STRIKE = "\xcc\xb6" -- U+0336 combining long stroke overlay

	local saved_a = { vim.fn.getreg("a"), vim.fn.getregtype("a") }

	-- Yank selection into reg a; gv handles both visual-active and marks-only state
	local in_visual = vim.fn.mode():find("[vV\22]") ~= nil
	vim.cmd(in_visual and 'normal! "ay' or 'normal! gv"ay')
	local text = vim.fn.getreg("a")
	local reg_type = vim.fn.getregtype("a")

	local b = text:byte(1)
	local first_len = b and (b < 0x80 and 1 or b < 0xE0 and 2 or b < 0xF0 and 3 or 4) or 0
	local is_struck = first_len > 0 and text:sub(first_len + 1, first_len + 2) == STRIKE

	local new_text
	if is_struck then
		new_text = text:gsub(STRIKE, "")
	else
		local result, i = {}, 1
		while i <= #text do
			local byte = text:byte(i)
			local len = byte < 0x80 and 1 or byte < 0xE0 and 2 or byte < 0xF0 and 3 or 4
			local c = text:sub(i, i + len - 1)
			result[#result + 1] = c ~= "\n" and c .. STRIKE or c
			i = i + len
		end
		new_text = table.concat(result)
	end

	vim.fn.setreg("a", new_text, reg_type)
	vim.cmd('normal! gv"ap')

	vim.fn.setreg("a", saved_a[1], saved_a[2])
end

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = Config("which-key", function(wk)
		wk.setup({
			preset = "modern",
			triggers = {
				{ "<leader>", mode = { "n", "v" } },
			},
		})

		wk.add({
			{ "<leader>x", Logger, desc = "Logger", mode = { "n", "v" } },
			{ "<leader>X", LoggerSP, desc = "LoggerSp", mode = { "n", "v" } },
			{ "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
			{
				"<leader>f",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Find files",
			},
			{ "<leader>F", "<cmd>Telescope live_grep theme=ivy<cr>", desc = "Find Text" },
			{ "<leader>P", PasteToQf, desc = "Paste to qf" },
			{ "<leader>pl", paste_link, desc = "Paste link" },
			{ "<leader>nr", "<cmd>NvimTreeRefresh<cr>", desc = "Refresh Tree" },
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
			{
				"<leader>gn",
				function()
					require("gitsigns").nav_hunk("next")
				end,
				desc = "Next Hunk",
			},
			{
				"<leader>gN",
				function()
					require("gitsigns").nav_hunk("next", { target = "all" })
				end,
				desc = "Next Hunk (All)",
			},
			{
				"<leader>gp",
				function()
					require("gitsigns").nav_hunk("prev")
				end,
				desc = "Prev Hunk",
			},
			{
				"<leader>gb",
				function()
					require("gitsigns").blame_line()
				end,
				desc = "Blame",
			},
			{
				"<leader>gv",
				function()
					require("gitsigns").preview_hunk()
				end,
				desc = "Preview Hunk",
			},
			{
				"<leader>gr",
				function()
					require("gitsigns").reset_hunk()
				end,
				desc = "Reset Hunk",
			},
			{ "<leader>gs", "<cmd>Gvdiffsplit!<cr>", desc = "Fugitive Split" },
			{ "<leader>gS", FullGitSplit, desc = "Fugitive custom split" },
			{ "<leader>gh", "<cmd>diffget //2<cr>", desc = "Pick left" },
			{ "<leader>gl", "<cmd>diffget //3<cr>", desc = "Pick right" },
			{
				"<leader>gR",
				function()
					require("gitsigns").reset_buffer()
				end,
				desc = "Reset Buffer",
			},
			{ "<leader>gP", "<cmd>lua ViewPrOfLine()<cr>", desc = "View pr of line" },
			{
				"<leader>ga",
				function()
					require("gitsigns").stage_hunk()
				end,
				desc = "toggle Add/Undo stage Hunk",
			},
			{
				"<leader>gA",
				function()
					local file = vim.api.nvim_buf_get_name(0)
					vim.system({ "git", "add", "--", file }, { cwd = vim.fs.dirname(file) }, function(result)
						vim.schedule(function()
							if result.code == 0 then
								require("gitsigns").refresh()
								vim.notify(vim.fs.basename(file) .. " added")
							else
								vim.notify("git add failed: " .. (result.stderr or ""), vim.log.levels.ERROR)
							end
						end)
					end)
				end,
				desc = "Add untracked file",
			},
			{ "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff" },
			{ "<leader>gf", "<cmd>Telescope git_status<cr>", desc = "Git Status Files" },
			{ "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
			{ "<leader>ld", "<cmd>Telescope lsp_document_diagnostics<cr>", desc = "Document Diagnostics" },
			{ "<leader>lw", "<cmd>Telescope lsp_workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
			{ "<leader>li", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
			{ "<leader>lI", "<cmd>Mason<cr>", desc = "Mason" },
			{ "<leader>lN", jump({ direction = FORWARD }), desc = "Next Diagnostic" },
			{ "<leader>lP", jump({ direction = BACKWARD }), desc = "Prev Diagnostic" },
			{
				"<leader>ln",
				jump({ direction = FORWARD, severity = vim.diagnostic.severity.ERROR }),
				desc = "Next Error",
			},
			{
				"<leader>lp",
				jump({ direction = BACKWARD, severity = vim.diagnostic.severity.ERROR }),
				desc = "Prev Error",
			},
			{ "<leader>ll", vim.lsp.codelens.run, desc = "CodeLens Action" },
			{ "<leader>lq", vim.diagnostic.setqflist, desc = "Quickfix" },
			{ "<leader>lr", vim.lsp.buf.rename, desc = "Rename" },
			{ "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
			{ "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
			{
				"<leader>tt",
				function()
					local enable = not vim.g.transparent_enabled
					require("transparent").toggle(enable)
				end,
				desc = "Toggle Transparency",
			},
			{
				"<leader>tm",
				function()
					require("render-markdown").toggle()
				end,
				desc = "Toggle markdown",
			},
			{ "<leader>tw", ToggleSetWrap, desc = "Toggle text wrap" },
			{
				"<leader>tr",
				function()
					if require("render-markdown.state").enabled then
						require("render-markdown").disable()
						vim.wo.wrap = false
					else
						require("render-markdown").enable()
						vim.wo.wrap = true
					end
				end,
				desc = "Toggle read (markdown + wrap)",
			},
			{ "<leader>tb", ToggleBool, desc = "Toggle boolean" },
			{ "<leader>tl", ToggleRelativeNumber, desc = "Toggle relative number" },
			{
				"<leader>ts",
				function()
					vim.opt_local.spell = not vim.opt_local.spell:get()
					vim.opt_local.spelllang = { "es", "en" }
				end,
				desc = "Toggle spelling (ES/EN)",
			},
			{ "<leader>vt", TestToggler, desc = "View test file" },
			{ "<leader>vd", "<cmd>tab DBUI<cr>", desc = "View database client" },
			{
				"<leader>ti",
				function()
					if vim.lsp.inlay_hint.is_enabled() then
						vim.lsp.inlay_hint.enable(false)
					else
						vim.lsp.inlay_hint.enable()
					end
				end,
				desc = "Toggle inlay hints",
			},
			{ "<leader>vq", ToggleQf, desc = "View qf list" },
			{ "<leader>ss", toggle_strikethrough, desc = "Toggle strikethrough", mode = "v" },
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
							"-g=!poetry.lock",
							-- this
							"-g=!*__tests__*",
							"-g=!*__test__*",
							"-g=!*test*.py",
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
			{ "<leader>l", group = "LSP" },
			{ "<leader>lz", "<cmd>Lazy sync<cr>", desc = "Plugins sync" },
			{ "<leader>lh", "<cmd>Lazy health<cr>", desc = "Plugins health" },
			{ "<leader>by", Cppath, desc = "Copy File Path" },
			{ "<leader>bY", CppathHome, desc = "Copy File Path (from home)" },
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
			{
				"<leader>b0",
				function()
					require("bufferline").close_others()
					require("bufdelete").bufdelete(0, true)
					Exec("Alpha")
				end,
				desc = "Zero buffer",
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
				"<leader>ri",
				function()
					return require("refactoring").inline_var()
				end,
				desc = "Inline Variable",
				expr = true,
			},
			{
				"<leader>rI",
				function()
					return require("refactoring").inline_func()
				end,
				desc = "Inline Function",
				expr = true,
			},
			{
				"<leader>rs",
				function()
					require("refactoring").select_refactor()
				end,
				desc = "Select Refactor",
			},
			{
				"<leader>rf",
				function()
					return require("refactoring").extract_func()
				end,
				desc = "Extract Function",
				mode = { "n", "v" },
				expr = true,
			},
			{
				"<leader>re",
				function()
					return require("refactoring").extract_func_to_file()
				end,
				desc = "Extract Function To File",
				mode = { "n", "v" },
				expr = true,
			},
			{
				"<leader>rv",
				function()
					return require("refactoring").extract_var()
				end,
				desc = "Extract Variable",
				mode = { "n", "v" },
				expr = true,
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

		local prompts = require("zsb.prompts")
		wk.add({
			{ "<leader>p", group = "Prompt" },
			prompt_with_desc("<leader>pr", prompts.ponytail_review),
			prompt_with_desc("<leader>pd", prompts.debug),
			prompt_with_desc("<leader>pa", prompts.ask),
			prompt_with_desc("<leader>pj", prompts.jira),
			prompt_with_desc("<leader>pc", prompts.pc),
			prompt_with_desc("<leader>pm", prompts.merge_conflicts),
			prompt_with_desc("<leader>pt", prompts.tdd),
			prompt_with_desc("<leader>ps", prompts.sheaper_prompts),
			prompt_with_desc("<leader>po", prompts.post_pr_comments_online),
		})
	end),
}
