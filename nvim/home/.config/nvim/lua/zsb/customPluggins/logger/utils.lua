local M = {}

--- @param mode "v" | nil "v" or nil
M.getSlot = function(mode)
	if mode == "v" then
		return GetVisualSelection()
	else
		return '<Esc>"xpa'
	end
end

--- @param logStatement string The statement to log
--- @param opts { after: string } | nil
--- @param opts.after string The text to insert after the log statement
M.doLog = function(logStatement, opts)
	local o = opts or {}

	local after = o.after or ""
	Execute('normal<Esc>"xyiwo' .. logStatement .. "<Esc><left><left>" .. after)
end

--- @param dictionary table
--- @param mode "v" | nil "v" or nil
--- @param onErrMsg string The message to show when the extension is not found
M.executeLogger = function(dictionary, mode, onErrMsg)
	local extension = vim.fn.expand("%:e")
	local fun = dictionary[extension]

	if fun == nil then
		vim.notify(onErrMsg .. " for '" .. extension .. "' extension")
		return
	end

	fun(mode)
end

return M
