local M = {}

--- @param mode? "v"
local function getSlot(mode)
	if mode == "v" then
		return GetVisualSelection()
	else
		return '<Esc>"xpa'
	end
end

--- @param logStatement string The statement to log
--- @param opts? { after: string }
--- @param opts.after string keys to execute after log statement
M.doLog = function(logStatement, opts)
	local o = opts or {}

	local after = o.after or ""
	Execute('normal<Esc>"xyiwo' .. logStatement .. "<Esc><left><left>" .. after)
end

--- @param dictionary table
--- @param onErrMsg string The message to show when the extension is not found
--- @param mode? "v"
M.executeLogger = function(dictionary, onErrMsg, mode)
	local extension = vim.fn.expand("%:e")
	local fun = dictionary[extension]

	if fun == nil then
		vim.notify(onErrMsg .. " for '" .. extension .. "' extension")
		return
	end

	fun(getSlot(mode))
end

return M
