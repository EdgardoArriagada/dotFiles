-- @param a, b = pcall(a, b)
-- @param handlers: table with:
-- onOk: function(result of pcall) | string | nothing
-- onErr: function(result of pcall) | string | nothing
function hpcall(a, b, handlers)
	local ok, thing = pcall(a, b)

	local action = ok and "onOk" or "onErr"

	local currAction = handlers[action]
	local actionType = type(currAction)

	if actionType == "function" then
		currAction(thing, ok)
	elseif actionType == "string" then
		vim.notify(currAction)
	end
end
