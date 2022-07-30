if vim.g.vscode then
	return
end

local group = vim.api.nvim_create_augroup("zsb", { clear = true })

vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]])

vim.api.nvim_create_autocmd("FileType", {
	pattern = "json",
	callback = function()
		vim.opt.foldmethod = "syntax"
		vim.schedule(function()
			execute("normal!zA")
			print('Folds set to "syntax"')
		end)
	end,
  group = group,
})
