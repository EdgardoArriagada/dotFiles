local js = require("zsb.customPluggins.testToggler.js")
local go = require("zsb.customPluggins.testToggler.go")

local extensionToToggler = {
	["javascript"] = js,
	["typescript"] = js,
	["javascriptreact"] = js,
	["typescriptreact"] = js,
	["go"] = go,
}

function TestToggler()
	local ft = vim.bo.filetype

	local toggler = extensionToToggler[ft]

	if toggler == nil then
		vim.notify("No toggler configured for '" .. ft .. "' filetype")
		return
	end

	if toggler.isTestFile() then
		Exec("e " .. toggler.getProductionCodeFile())
	else
		Exec("e " .. toggler.getTestFile())
	end
end
