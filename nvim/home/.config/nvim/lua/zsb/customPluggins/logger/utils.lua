local M = {}

local function getSlot()
	local mode = vim.api.nvim_get_mode()["mode"]

	if mode == "v" then
		return GetVisualSelection()
	else
		return '<Esc>"xpa'
	end
end

local function getOpener()
	local mode = vim.api.nvim_get_mode()["mode"]

	if mode == "v" then
		return "o"
	else
		return '"xyiwo'
	end
end

--- @param logStatement string The statement to log
--- @param opts? { after: string }
--- @param opts.after string keys to execute after log statement
M.doLog = function(logStatement, opts)
	local o = opts or {}

	local opener = getOpener()

	local after = o.after or ""
	Execute("normal<Esc>" .. opener .. logStatement .. "<Esc><left><left>" .. after)
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
