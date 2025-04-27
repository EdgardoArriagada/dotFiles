-- vim.notify modifiers
INFO = vim.log.levels.INFO -- default
WARN = vim.log.levels.WARN
ERROR = vim.log.levels.ERROR

Indent = vim.fn.indent

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
