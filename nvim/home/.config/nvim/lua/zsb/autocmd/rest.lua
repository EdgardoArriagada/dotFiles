--[[ if vim.g.vscode then return end ]]

Cautocmd("FileType", {
	pattern = "json",
	callback = function(m)
		if StartsWith("/Users/", m.file) or not HasBufCorrectSize(m.buf) then
			return
		end

		vim.o.foldmethod = "expr"
		vim.o.foldexpr = "nvim_treesitter#foldexpr()"

		SetTimeout(function()
			Hpcall(Exec, "normal!zA", { onErr = 'failed to execute ":normal!zA"' })
		end, 50)
	end,
	group = Group,
})

-- - Open any ts file so TS language loads
-- - run :make and then open qflist
--[[ Cautocmd("FileType", { ]]
--[[ 	pattern = "typescript,typescriptreact", ]]
--[[ 	group = Group, ]]
--[[ 	command = "compiler tsc | setlocal makeprg=npx\\ tsc", ]]
--[[ }) ]]

-- Triger `autoread` when files changes on disk
Cautocmd(
	{ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" },
	{ command = [[if mode() != 'c' | checktime | endif]], group = Group }
)

-- Notification after file change
Cautocmd("FileChangedShellPost", {
	callback = function()
		vim.notify("File changed on disk. Buffer reloaded.", WARN)
	end,
	group = Group,
})
