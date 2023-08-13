--[[ if vim.g.vscode then return end ]]
local group = vim.api.nvim_create_augroup("zsb", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.lsp.buf.format({ async = true })
	end,
	group = group,
})

-- Use internal formatting for bindings like gq.
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.bo[args.buf].formatexpr = nil
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "json",
	callback = function()
		vim.opt.foldmethod = "syntax"
		vim.schedule(function()
			Hpcall(Execute, "normal!zA", { onErr = 'failed to execute ":normal!zA"' })
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
