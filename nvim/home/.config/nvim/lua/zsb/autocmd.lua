--[[ if vim.g.vscode then return end ]]
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local defaultGroup = augroup("zsb", { clear = true })

autocmd("BufWritePre", {
	callback = function()
		vim.lsp.buf.format({ async = true })
	end,
	group = defaultGroup,
})

-- Use internal formatting for bindings like gq.
autocmd("LspAttach", {
	callback = function(args)
		vim.bo[args.buf].formatexpr = nil
	end,
})

autocmd("FileType", {
	pattern = "json",
	callback = function()
		vim.opt.foldmethod = "syntax"
		vim.schedule(function()
			Hpcall(Execute, "normal!zA", { onErr = 'failed to execute ":normal!zA"' })
		end)
	end,
	group = defaultGroup,
})

-- Triger `autoread` when files changes on disk
autocmd(
	{ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" },
	{ command = [[if mode() != 'c' | checktime | endif]], group = defaultGroup }
)

-- Notification after file change
autocmd("FileChangedShellPost", {
	callback = function()
		Warn("File changed on disk. Buffer reloaded.")
	end,
	group = defaultGroup,
})
