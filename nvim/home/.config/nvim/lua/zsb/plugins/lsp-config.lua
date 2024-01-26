local configServers = {
	pyright = {},
	cssls = {},
	emmet_language_server = {},
	tailwindcss = {},
	bashls = {},
	gopls = {},
	rust_analyzer = {},
	lua_ls = {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim", "hs", "table", "kset", "createCmd" },
				},
			},
		},
	},
	tsserver = {
		commands = {
			OrganizeImports = {
				function()
					vim.lsp.buf.execute_command({
						command = "_typescript.organizeImports",
						arguments = { vim.api.nvim_buf_get_name(0) },
						title = "",
					})
				end,
				description = "Organize Imports",
			},
		},
	},
}

local serverNames = {}

for server, _ in pairs(configServers) do
	table.insert(serverNames, server)
end

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
				ensure_installed = serverNames,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "InsertEnter",
		config = function()
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

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

			for serverName, config in pairs(configServers) do
				lspconfig[serverName].setup(Extend(defaultSetUp, config))
			end
		end,
	},
}
