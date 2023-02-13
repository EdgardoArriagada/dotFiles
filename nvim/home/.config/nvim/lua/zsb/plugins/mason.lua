---@diagnostic disable-next-line: undefined-global
local Vim = vim

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
			local function buf_set_keymap(...)
				Vim.api.nvim_buf_set_keymap(bufnr, ...)
			end
			local function buf_set_option(...)
				Vim.api.nvim_buf_set_option(bufnr, ...)
			end

			buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

			local opts = { noremap = true, silent = true }

			Vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
			Vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
			Vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
			Vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
			Vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
			Vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
			Vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
		end

		local _capabilities = Vim.lsp.protocol.make_client_capabilities()
		local capabilities = require("cmp_nvim_lsp").default_capabilities(_capabilities)

		local lspconfig = require("lspconfig")

		lspconfig["pyright"].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig["cssls"].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig["emmet_ls"].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig["tsserver"].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig["lua_ls"].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig["bashls"].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig["gopls"].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end,
}
