local M = {}

local function indentString(input, row)
	return string.rep(" ", vim.fn.indent(row)) .. input
end

local function appendInNextLine(logStatement)
	local row = unpack(vim.api.nvim_win_get_cursor(0))

	vim.api.nvim_buf_set_lines(0, row, row, false, { indentString(logStatement, row) })
end

local DEFAULT_OPTIONS = {
	after = "",
}

local function parseOptions(options)
	if options == nil then
		return DEFAULT_OPTIONS
	end

	return {
		after = options.after or DEFAULT_OPTIONS.after,
	}
end

local function getSlot()
	local mode = vim.api.nvim_get_mode()["mode"]

	if mode == "v" then
		return GetVisualSelection()
	elseif mode == "V" then
		return vim.api.nvim_get_current_line()
	else
		return vim.fn.expand("<cword>")
	end
end

--- @param logStatement string The statement to log
--- @param options? { after: string }
--- @param options.after string keys to execute after log statement
M.doLog = function(logStatement, options)
	local opts = parseOptions(options)

	appendInNextLine(logStatement)

	Execute("normal<Esc>j$<left><left>" .. opts.after)
end

--- @param dictionary table
--- @param onErrMsg string The message to show when the extension is not found
M.executeLogger = function(dictionary, onErrMsg)
	local extension = vim.fn.expand("%:e")
	local fun = dictionary[extension]

	if fun == nil then
		vim.notify(onErrMsg .. " for '" .. extension .. "' extension")
		return
	end

	fun(getSlot())
end

return M
