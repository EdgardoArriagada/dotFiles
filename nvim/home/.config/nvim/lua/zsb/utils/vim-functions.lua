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

-- merge given tables
function Expand(...)
	local args = { ... }
	local result = args[1]

	for i = 2, #args do
		result = vim.tbl_deep_extend("force", result, args[i])
	end

	return result
end
