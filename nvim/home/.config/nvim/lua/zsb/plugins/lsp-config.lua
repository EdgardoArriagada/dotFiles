return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"tsserver",
					"pyright",
					"cssls",
					"emmet_ls",
					"tailwindcss",
					"bashls",
					"gopls",
					"rust_analyzer",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			local function organize_imports()
				local params = {
					command = "_typescript.organizeImports",
					arguments = { vim.api.nvim_buf_get_name(0) },
					title = "",
				}
				vim.lsp.buf.execute_command(params)
			end

			local on_attach = function(_, bufnr)
				local opts = { noremap = true, silent = true }
				local function set_keymap(...)
					vim.api.nvim_buf_set_keymap(bufnr, ...)
				end

				set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
				set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
				set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
				set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
				set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
				set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
				set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
				set_keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
			end

			local defaultSetUp = {
				on_attach = on_attach,
				capabilities = capabilities,
			}

			local lspconfig = require("lspconfig")

			lspconfig["lua_ls"].setup(Extend(defaultSetUp, {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim", "hs", "table", "kset", "createCmd" },
						},
					},
				},
			}))

			lspconfig["tsserver"].setup(Extend(defaultSetUp, {
				commands = {
					OrganizeImports = {
						organize_imports,
						description = "Organize Imports",
					},
				},
			}))

			local defaultConfigServers = {
				"pyright",
				"cssls",
				"emmet_ls",
				"tailwindcss",
				"bashls",
				"gopls",
				"rust_analyzer",
			}

			for _, server in pairs(defaultConfigServers) do
				lspconfig[server].setup(defaultSetUp)
			end
		end,
	},
}
