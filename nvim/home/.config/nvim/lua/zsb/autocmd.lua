--[[ if vim.g.vscode then return end ]]
local autocmd = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("Zsb", { clear = true })

-- Use internal formatting for bindings like gq.
autocmd("LspAttach", {
	callback = function(args)
		vim.bo[args.buf].formatexpr = nil
	end,
	group = group,
})

autocmd("FileType", {
	pattern = "json",
	callback = function(m)
		if StartsWith("/Users/", m.file) or not HasBufCorrectSize(m.buf) then
			return
		end

		vim.o.foldmethod = "expr"
		vim.o.foldexpr = "nvim_treesitter#foldexpr()"

		vim.uv.new_timer():start(
			300,
			0,
			vim.schedule_wrap(function()
				Hpcall(Exec, "normal!zA", { onErr = 'failed to execute ":normal!zA"' })
			end)
		)
	end,
	group = group,
})

-- - Open any ts file so TS language loads
-- - run :make and then open qflist
--[[ autocmd("FileType", { ]]
--[[ 	pattern = "typescript,typescriptreact", ]]
--[[ 	group = group, ]]
--[[ 	command = "compiler tsc | setlocal makeprg=npx\\ tsc", ]]
--[[ }) ]]

-- Triger `autoread` when files changes on disk
autocmd(
	{ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" },
	{ command = [[if mode() != 'c' | checktime | endif]], group = group }
)

-- Notification after file change
autocmd("FileChangedShellPost", {
	callback = function()
		vim.notify("File changed on disk. Buffer reloaded.", "warn")
	end,
	group = group,
})
