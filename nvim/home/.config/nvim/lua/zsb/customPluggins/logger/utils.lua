local M = {}

M.getSlot = function(mode)
	if mode == "v" then
		return GetVisualSelection()
	else
		return '<Esc>"xpa'
	end
end

M.doLog = function(logStatement, _opts)
	local opts = _opts or {}

	local after = opts.after or ""
	Execute('normal<Esc>"xyiwo' .. logStatement .. "<Esc><left><left>" .. after)
end

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
