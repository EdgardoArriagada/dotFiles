--[[ if vim.g.vscode then return end ]]
local autocmd = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("Zsb", { clear = true })

autocmd("BufWritePre", {
	callback = function()
		vim.lsp.buf.format({ async = true })
	end,
	group = group,
})

-- Use internal formatting for bindings like gq.
autocmd("LspAttach", {
	callback = function(args)
		vim.bo[args.buf].formatexpr = nil
	end,
	group = group,
})

autocmd("FileType", {
	pattern = "json",
	callback = function()
		vim.opt.foldmethod = "syntax"
		--[[ vim.schedule(function() ]]
		--[[ 	Hpcall(Execute, "normal!zA", { onErr = 'failed to execute ":normal!zA"' }) ]]
		--[[ end) ]]
	end,
	group = group,
})

-- Triger `autoread` when files changes on disk
autocmd(
	{ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" },
	{ command = [[if mode() != 'c' | checktime | endif]], group = group }
)

-- Notification after file change
autocmd("FileChangedShellPost", {
	callback = function()
		Warn("File changed on disk. Buffer reloaded.")
	end,
	group = group,
})
