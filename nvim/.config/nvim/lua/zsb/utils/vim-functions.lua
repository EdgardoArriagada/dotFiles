function Warn(msg)
	vim.api.nvim_echo({ { msg, "WarningMsg" } }, true, {})
end

indent = vim.fn.indent
line = vim.fn.line

keymap = vim.keymap
getCurrentLine = vim.api.nvim_get_current_line

getpos = vim.fn.getpos
setpos = vim.fn.setpos
cursor = vim.fn.cursor
col = vim.fn.col
