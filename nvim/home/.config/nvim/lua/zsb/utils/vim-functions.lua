if not table.unpack then
	table.unpack = unpack
end

function Warn(msg)
	vim.api.nvim_echo({ { msg, "WarningMsg" } }, true, {})
end

indent = vim.fn.indent
line = vim.fn.line

kset = vim.keymap.set
getCurrentLine = vim.api.nvim_get_current_line

getpos = vim.fn.getpos
setpos = vim.fn.setpos
cursor = vim.fn.cursor
col = vim.fn.col

-- merge given tables without mutating them
function Extend(...)
	return vim.tbl_deep_extend("force", ...)
end
