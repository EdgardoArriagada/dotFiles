--- @class Toggler
--- @field isTestFile function: Returns true if the current file is a test file, false otherwise
--- @field getTestFile function: Returns the path to the test file
--- @field getProductionCodeFile function: Returns the path to the production code file

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
