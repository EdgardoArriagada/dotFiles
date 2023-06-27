return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function()
		require("mason").setup()

		require("mason-lspconfig").setup()

		local on_attach = function(_client, bufnr)
			local opts = { noremap = true, silent = true }

			vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
			vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
			vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
			vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
			vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
			vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
			vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
		end

		local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

		local defaultSetUp = {
			on_attach = on_attach,
			capabilities = capabilities,
		}

		local lspconfig = require("lspconfig")

		lspconfig["lua_ls"].setup(Extend(defaultSetUp, {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim", "hs", "table" },
					},
				},
			},
		}))

		local defaultConfigServers = {
			"pyright",
			"cssls",
			"emmet_ls",
			"tsserver",
			"tailwindcss",
			"bashls",
			"gopls",
			"rust_analyzer",
		}

		for _, server in pairs(defaultConfigServers) do
			lspconfig[server].setup(defaultSetUp)
		end
	end,
}
