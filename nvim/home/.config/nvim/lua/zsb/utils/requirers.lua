-- @param a, b = pcall(a, b)
-- @param handlers: table with:
-- onOk: function(result of pcall) | string | nothing
-- onErr: function(result of pcall) | string | nothing
function Hpcall(a, b, handlers)
	local ok, thing = pcall(a, b)

	local currAction = handlers[ok and "onOk" or "onErr"]
	local actionType = type(currAction)

	if actionType == "function" then
		currAction(thing, ok)
	elseif actionType == "string" then
		vim.notify(currAction)
	end
end
