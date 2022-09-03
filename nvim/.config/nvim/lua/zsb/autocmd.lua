if vim.g.vscode then
	return
end

local group = vim.api.nvim_create_augroup("zsb", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.lsp.buf.formatting_sync()
	end,
	group = group,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "json",
	callback = function()
		vim.opt.foldmethod = "syntax"
		vim.schedule(function()
			withFallback(execute, "normal!zA", function()
				vim.notify('failed to execute "normal!zA"')
			end)
		end)
	end,
	group = group,
})
