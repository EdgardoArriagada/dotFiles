-- For now, this script is only usefull for logging crashes.
-- the 'return thing' statement will be usefull
-- when we find a way to exit original script using the callback
--
function withFallback(a, b, cb)
	local ok, thing = pcall(a, b)

	if not ok then
		cb()
	end

	return thing
end

function whenOk(a, b, cb)
	local ok, thing = pcall(a, b)

	if not ok then
		return
	end

	cb(thing)
end

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
