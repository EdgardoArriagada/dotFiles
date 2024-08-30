local js = require("zsb.customPluggins.testToggler.js")
local go = require("zsb.customPluggins.testToggler.go")

local extensionToFunction = {
	["javascript"] = js.toggle,
	["typescript"] = js.toggle,
	["javascriptreact"] = js.toggle,
	["typescriptreact"] = js.toggle,
	["go"] = go.toggle,
}

function TestToggler()
	local ft = vim.bo.filetype

	local fun = extensionToFunction[ft]

	if fun == nil then
		vim.notify("No toggler configured for '" .. ft .. "' filetype")
		return
	end

	fun()
end
