M = {}

local function isTestFile()
	local currentFile = vim.fn.expand("%:t")

	return string.match(currentFile, "_test.go$")
end

local function getTestFile()
	vim.notify("getTestFile not implemented")
end

local function getProductionCodeFile()
	vim.notify("getProductionCodeFile not implemented")
end

M.toggle = function()
	if isTestFile() then
		--[[ Exec("e " .. getProductionCodeFile()) ]]
		getProductionCodeFile()
	else
		--[[ Exec("e " .. getTestFile()) ]]
		getTestFile()
	end
end

return M
