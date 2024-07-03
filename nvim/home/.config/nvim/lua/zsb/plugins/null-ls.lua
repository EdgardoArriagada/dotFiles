return {
	"nvimtools/none-ls.nvim",
	config = Config("null-ls", function(null_ls)
		-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
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
				-- elixir
				f.mix,
				d.credo,
				-- golang
				f.gofmt,
				d.golangci_lint,
			},
			on_attach = function(client, bufnr)
				-- https://github.com/nvimtools/none-ls.nvim/wiki/Formatting-on-save
				if not client.supports_method("textDocument/formatting") then
					return
				end

				local common = {
					group = augroup,
					buffer = bufnr,
				}

				vim.api.nvim_clear_autocmds(common)
				vim.api.nvim_create_autocmd(
					"BufWritePre",
					Extend(common, {
						callback = function()
							vim.lsp.buf.format({
								bufnr = bufnr,
								filter = function(c)
									return c.name == "null-ls"
								end,
							})
						end,
					})
				)
			end,
		})
	end),
}
