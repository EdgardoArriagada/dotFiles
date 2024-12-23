-- vim.notify modifiers
INFO = 2 -- default
WARN = 3
ERROR = 4

Indent = vim.fn.indent
Line = vim.fn.line

Kset = vim.keymap.set
-- autocommand
Cautocmd = vim.api.nvim_create_autocmd

function CreateAugroup(name)
	return vim.api.nvim_create_augroup(name, { clear = true })
end

Group = CreateAugroup("Zsb")

-- merge given tables without mutating them
function DeepExtend(...)
	return vim.tbl_deep_extend("force", ...)
end

-- merge given tables without mutating them
function Extend(...)
	return vim.tbl_extend("force", ...)
end
