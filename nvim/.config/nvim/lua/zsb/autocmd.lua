--[[ if vim.g.vscode then return end ]]

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
			hpcall(execute, "normal!zA", { onErr = 'failed to execute ":normal!zA"' })
		end)
	end,
	group = group,
})

-- Triger `autoread` when files changes on disk
vim.api.nvim_create_autocmd(
	{ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" },
	{ command = [[if mode() != 'c' | checktime | endif]], group = group }
)

-- Notification after file change
vim.api.nvim_create_autocmd("FileChangedShellPost", {
	callback = function()
		Warn("File changed on disk. Buffer reloaded.")
	end,
	group = group,
})
