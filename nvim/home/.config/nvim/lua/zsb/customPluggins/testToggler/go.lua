M = {}

local function isTestFile()
	local currentFile = vim.fn.expand("%:t")

	return string.find(currentFile, "_test.go$")
end

local function getTestFile()
	local basename = vim.fn.expand("%:t"):match("^[^.]+")

	return vim.fn.expand("%:h") .. "/" .. basename .. "_test.go"
end

local function getProductionCodeFile()
	vim.notify("getProductionCodeFile not implemented")
end

M.toggle = function()
	if isTestFile() then
		--[[ Exec("e " .. getProductionCodeFile()) ]]
		getProductionCodeFile()
	else
		Exec("e " .. getTestFile())
	end
end

return M
