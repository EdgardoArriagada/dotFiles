local M = {}

local function getSlot()
	local mode = vim.api.nvim_get_mode()["mode"]

	if mode == "v" then
		return GetVisualSelection()
	else
		return vim.fn.expand("<cword>")
	end
end

local function parseOptions(options)
	local opts = options or {}
	local after = opts.after or ""
	return after
end

--- @param logStatement string The statement to log
--- @param options? { after: string }
--- @param options.after string keys to execute after log statement
M.doLog = function(logStatement, options)
	local after = parseOptions(options)

	local row = unpack(vim.api.nvim_win_get_cursor(0))
	vim.api.nvim_buf_set_lines(0, row, row, false, { logStatement })

	Execute("normal<Esc>j$<Esc><left><left>" .. after)
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
