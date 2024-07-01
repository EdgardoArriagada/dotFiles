-- https://luals.github.io/wiki/annotations/

--- @param a function First param of pcall
--- @param b string Second param of pcall
--- @alias handler string | function
--- @param handlers { onOk?: handler, onErr?: handler } What to do onOk or onErr
function Hpcall(a, b, handlers)
	local ok, thing = pcall(a, b)

	local currHandler = handlers[ok and "onOk" or "onErr"]
	local handlerType = type(currHandler)

	if handlerType == "function" then
		currHandler(thing)
	elseif handlerType == "string" then
		vim.notify(currHandler)
	end
end

--- @param plugin string What to require
--- @param fn function What to do onOk
function Config(plugin, fn)
	return function()
		local ok, content = pcall(require, plugin)

		if not ok then
			return vim.notify("Error: could not load '" .. plugin .. "'")
		end

		fn(content)
	end
end
