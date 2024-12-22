return {
	"nvimtools/none-ls.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = Config("null-ls", function(plugin)
		-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		local f = plugin.builtins.formatting
		local d = plugin.builtins.diagnostics

		plugin.setup({
			debug = false,
			sources = {
				-- javascript
				f.prettierd,
				require("none-ls.diagnostics.eslint_d"),
				-- rust
				--[[ f.rustfmt, ]]
				-- python
				f.black,
				require("none-ls.diagnostics.flake8"),
				-- lua
				f.stylua,
				-- elixir
				f.mix,
				d.credo,
				-- golang
				f.gofmt,
				--[[ d.golangci_lint, ]]
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
				Cautocmd(
					"BufWritePre",
					Extend(common, {
						callback = function()
							vim.lsp.buf.format({
								async = false,
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
