M = {}

local function isTestFile()
	local currentFile = vim.fn.expand("%:t")

	return string.find(currentFile, "_test.go$")
end

local function getTestFile()
	local basename = vim.fn.expand("%:t"):match("^[^.]+")

	return vim.fn.expand("%:h") .. "/" .. basename .. "_test.go"
end

local function listCurrentDir(glob)
	return vim.fn.globpath(vim.fn.expand("%:h"), glob, true, true)
end

local function getProductionCodeFile()
	local basename = vim.fn.expand("%:t"):gsub("_test.go$", "")

	local prodFile = listCurrentDir("*" .. basename .. ".*go")[1]

	if prodFile then
		return prodFile
	else
		return vim.fn.expand("%:h") .. "/" .. basename .. ".go"
	end
end

M.toggle = function()
	if isTestFile() then
		Exec("e " .. getProductionCodeFile())
	else
		Exec("e " .. getTestFile())
	end
end

return M
