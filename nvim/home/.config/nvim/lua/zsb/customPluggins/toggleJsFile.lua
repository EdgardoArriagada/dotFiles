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
	local ft = vim.fn.expand("%:e")
	local fileDir = vim.fn.expand("%:h")
	local testDir = fileDir .. "/__tests__/"
	local endFile = "%." .. ft .. "$"

	for _, ex in ipairs(JS_EXTENSIONS) do
		local extension = "%.spec%." .. ex
		local testFileName = fileName:gsub(endFile, extension)
		local isReadable = vim.fn.filereadable(testDir .. testFileName) ~= 0

		if isReadable then
			return testDir .. testFileName
		end
	end

	local extension = "%.spec%." .. ft
	local testFileName = fileName:gsub(endFile, extension)

	return testDir .. testFileName
end

local function getProductionCodeFileJS()
	local testFileName = vim.fn.expand("%:t")
	local ft = vim.fn.expand("%:e")
	local testFileDir = vim.fn.expand("%:h")
	local endFile = "%.spec%." .. ft .. "$"

	local fileDir = testFileDir:gsub("__tests__", "")

	for _, ex in ipairs(JS_EXTENSIONS) do
		local extension = "%." .. ex
		local fileName = testFileName:gsub(endFile, extension)
		local result = fileDir .. fileName

		local isReadable = vim.fn.filereadable(result) ~= 0

		if isReadable then
			return result
		end
	end

	local extension = "%." .. ft
	local fileName = testFileName:gsub(endFile, extension)

	return fileDir .. fileName
end

function ToggleJsFile()
	if isTestFileJs() then
		vim.cmd("e " .. getProductionCodeFileJS())
	else
		vim.cmd("e " .. getTestFileJs())
	end
end
