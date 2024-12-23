--- @class ZsbTestToggler
--- @field isTestFile function: Returns true if the current file is a test file, false otherwise
--- @field getTestFile function: Returns the path to the test file
--- @field getProductionCodeFile function: Returns the path to the production code file

local js = require("zsb.customPluggins.testToggler.js")
local go = require("zsb.customPluggins.testToggler.go")

--- @type table<string, ZsbTestToggler>
local extensionToZsbTestToggler = {
	["javascript"] = js,
	["typescript"] = js,
	["javascriptreact"] = js,
	["typescriptreact"] = js,
	["go"] = go,
}

function TestToggler()
	local ft = vim.bo.filetype

	local t = extensionToZsbTestToggler[ft]

	if not t then
		vim.notify("No test toggler configured for '" .. ft .. "' filetype", ERROR)
		return
	end

	if t.isTestFile() then
		Exec("e " .. t.getProductionCodeFile())
	else
		Exec("e " .. t.getTestFile())
	end
end
