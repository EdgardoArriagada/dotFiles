-- @param a, b = pcall(a, b)
-- @param handlers: table with:
-- onOk: function(result of pcall) | string | nothing
-- onErr: function(result of pcall) | string | nothing
function Hpcall(a, b, handlers)
	local ok, thing = pcall(a, b)

	local currHandler = handlers[ok and "onOk" or "onErr"]
	local handlerType = type(currHandler)

	if handlerType == "function" then
		currHandler(thing, ok)
	elseif handlerType == "string" then
		vim.notify(currHandler)
	end
end
