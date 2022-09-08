local onActionType = {
	["function"] = function(fn, ok, thing)
		fn(thing, ok)
	end,
	["string"] = function(str)
		vim.notify(str)
	end,
	["nil"] = function() end,
}

-- @param a, b = pcall(a, b)
-- @param handlers: table with:
-- onOk: function(result of pcall) | string | nothing
-- onErr: function(result of pcall) | string | nothing
function hpcall(a, b, handlers)
	local ok, thing = pcall(a, b)

	local action = ok and "onOk" or "onErr"

	onActionType[type(handlers[action])](handlers[action], ok, thing)
end
