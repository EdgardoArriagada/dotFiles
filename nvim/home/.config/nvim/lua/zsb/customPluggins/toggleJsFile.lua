local JS_EXTENSIONS = {
	"js",
	"jsx",
	"ts",
	"tsx",
}

local function isTestFileJs()
	local fileName = vim.fn.expand("%:t")
	local extension = vim.fn.expand("%:e")

	return string.match(fileName, "%.spec%." .. extension .. "$")
end

local function getTestFileJs()
	local fileName = vim.fn.expand("%:t")
	local extension = vim.fn.expand("%:e")
	local fileDir = vim.fn.expand("%:h")
	local testDir = fileDir .. "/__tests__/"
	local endFile = "%." .. extension .. "$"

	for _, ex in ipairs(JS_EXTENSIONS) do
		local testFileName = fileName:gsub(endFile, "%.spec%." .. ex)
		local isReadable = vim.fn.filereadable(testDir .. testFileName) ~= 0

		if isReadable then
			return testDir .. testFileName
		end
	end

	local testFileName = fileName:gsub(endFile, "%.spec%." .. extension)

	return testDir .. testFileName
end

local function getProductionCodeFileJS()
	local fileName = vim.fn.expand("%:t")
	local extension = vim.fn.expand("%:e")
	local testFileDir = vim.fn.expand("%:h")

	local productionCodeFileDir = testFileDir:gsub("__tests__", "")

	for _, ex in ipairs(JS_EXTENSIONS) do
		local productionCodeFileName = fileName:gsub("%.spec%." .. extension .. "$", "%." .. ex)
		local result = productionCodeFileDir .. productionCodeFileName
		local isReadable = vim.fn.filereadable(result) ~= 0

		if isReadable then
			return result
		end
	end

	local productionCodeFileName = fileName:gsub("%.spec%." .. extension .. "$", "%." .. extension)
	return productionCodeFileDir .. productionCodeFileName
end

function ToggleJsFile()
	if isTestFileJs() then
		vim.cmd("e " .. getProductionCodeFileJS())
	else
		vim.cmd("e " .. getTestFileJs())
	end
end
