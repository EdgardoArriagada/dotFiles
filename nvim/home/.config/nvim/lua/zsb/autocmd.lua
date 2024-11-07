--[[ if vim.g.vscode then return end ]]
local group = CreateAugroup("Zsb")

-- Use internal formatting for bindings like gq.
Cautocmd("LspAttach", {
	callback = function(args)
		vim.bo[args.buf].formatexpr = nil
	end,
	group = group,
})

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
	group = group,
})

-- - Open any ts file so TS language loads
-- - run :make and then open qflist
--[[ Cautocmd("FileType", { ]]
--[[ 	pattern = "typescript,typescriptreact", ]]
--[[ 	group = group, ]]
--[[ 	command = "compiler tsc | setlocal makeprg=npx\\ tsc", ]]
--[[ }) ]]

-- Triger `autoread` when files changes on disk
Cautocmd(
	{ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" },
	{ command = [[if mode() != 'c' | checktime | endif]], group = group }
)

-- Notification after file change
Cautocmd("FileChangedShellPost", {
	callback = function()
		vim.notify("File changed on disk. Buffer reloaded.", "warn")
	end,
	group = group,
})

Cautocmd("VimEnter", {
	callback = function()
		SetTimeout(function()
			vim.fn.system('tmux rename-window " $(get_repo_name)"')
		end, 0)
	end,
})

Cautocmd("VimLeave", {
	callback = function()
		vim.fn.system("tmux set automatic-rename")
	end,
})
