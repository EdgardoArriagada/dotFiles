Indent = vim.fn.indent
Line = vim.fn.line

kset = vim.keymap.set
createCmd = vim.api.nvim_create_user_command

-- merge given tables without mutating them
function DeepExtend(...)
	return vim.tbl_deep_extend("force", ...)
end

-- merge given tables without mutating them
function Extend(...)
	return vim.tbl_extend("force", ...)
end
