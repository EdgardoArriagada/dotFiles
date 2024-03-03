return {
	"nvimtools/none-ls.nvim",
	config = Config("null-ls", function(null_ls)
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
		local f = null_ls.builtins.formatting
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
		local d = null_ls.builtins.diagnostics

		null_ls.setup({
			debug = false,
			sources = {
				-- javascript
				--[[ f.prettierd, -- https://github.com/fsouza/prettierd#installation-guide ]]
				f.prettier,
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
				if client.name ~= "null-ls" then
					return
				end

				if client.supports_method("textDocument/formatting") then
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
				end
			end,
		})
	end),
}
