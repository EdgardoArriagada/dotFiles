if vim.g.vscode then
	return
end

hpcall(require, "null-ls", {
	onOk = function(null_ls)
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
		local formatting = null_ls.builtins.formatting
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
		local diagnostics = null_ls.builtins.diagnostics

		null_ls.setup({
			debug = false,
			sources = {
				formatting.prettierd,
				diagnostics.eslint_d,
				formatting.black,
				-- formatting.yapf,
				formatting.stylua,
				diagnostics.flake8,
			},
		})
	end,
})
