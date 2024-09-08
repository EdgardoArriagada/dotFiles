function Warn(msg)
	vim.notify(msg, "warn")
end

indent = vim.fn.indent
line = vim.fn.line

kset = vim.keymap.set
createCmd = vim.api.nvim_create_user_command

-- merge given tables without mutating them
function Extend(...)
	return vim.tbl_deep_extend("force", ...)
end
