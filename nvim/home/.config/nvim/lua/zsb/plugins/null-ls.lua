return {
	"jose-elias-alvarez/null-ls.nvim",
	dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim", "jay-babu/mason-null-ls.nvim" },
	config = function()
		hpcall(require, "null-ls", {
			onOk = function(null_ls)
				-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
				local formatting = null_ls.builtins.formatting
				-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
				local diagnostics = null_ls.builtins.diagnostics

				null_ls.setup({
					debug = false,
					sources = {
						-- javascript
						formatting.prettierd,
						diagnostics.eslint_d,
						-- rust
						formatting.rustfmt,
						-- [diagnostics: rust-analyzer LSP]
						-- python
						formatting.black,
						diagnostics.flake8,
						-- lua
						formatting.stylua,
					},
				})
			end,
		})
	end,
}
