return {
	"nvimtools/none-ls.nvim",
	config = function()
		Hpcall(require, "null-ls", {
			onOk = function(null_ls)
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
				})
			end,
		})
	end,
}
