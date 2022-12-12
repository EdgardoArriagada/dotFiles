local function jsLogger()
	Execute('normal<Esc>"xyiwoconsole.log(\'le <Esc>"xpa\', { <Esc>"xpa, })<Esc><left><left>')
end

local extensionToFunction = {
	["js"] = jsLogger,
	["ts"] = jsLogger,
	["jsx"] = jsLogger,
	["tsx"] = jsLogger,
}

function Logger()
	local extension = vim.fn.expand("%:e")
	local fun = extensionToFunction[extension]

	if fun ~= nil then
		fun()
	end
end
