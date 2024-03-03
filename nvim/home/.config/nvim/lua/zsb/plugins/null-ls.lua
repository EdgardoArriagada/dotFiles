return {
	"nvimtools/none-ls.nvim",
	config = Config("null-ls", function(null_ls)
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		local f = null_ls.builtins.formatting
		local d = null_ls.builtins.diagnostics

		null_ls.setup({
			debug = false,
			sources = {
				-- javascript
				f.prettierd,
				d.eslint_d,
				-- rust
				f.rustfmt,
				-- python
				f.black,
				d.flake8,
				-- lua
				f.stylua,
			},
			on_attach = function(client, bufnr)
				if not client.supports_method("textDocument/formatting") then
					return
				end

				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({
							filter = function(c)
								return c.name == "null-ls"
							end,
						})
					end,
				})
			end,
		})
	end),
}
