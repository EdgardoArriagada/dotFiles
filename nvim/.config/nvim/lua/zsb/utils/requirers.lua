local onActionType = {
	["function"] = function(fn, ok, thing)
		fn(thing, ok)
	end,
	["string"] = function(str)
		vim.notify(str)
	end,
	["nil"] = function() end,
}

function hpcall(a, b, args)
	local ok, thing = pcall(a, b)

	local action = ok and "onOk" or "onErr"

	onActionType[type(args[action])](args[action], ok, thing)
end
