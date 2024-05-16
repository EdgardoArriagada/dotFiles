local FILE_EXTENSIONS = {
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

	for _, ex in ipairs(FILE_EXTENSIONS) do
		local testFileName = fileName:gsub("%." .. extension .. "$", "%.spec%." .. ex)
		local isReadable = vim.fn.filereadable(fileDir .. "/__tests__/" .. testFileName) ~= 0

		if isReadable then
			return fileDir .. "/__tests__/" .. testFileName
		end
	end

	local testFileName = fileName:gsub("%." .. extension .. "$", "%.spec%." .. extension)

	return fileDir .. "/__tests__/" .. testFileName
end

local function getProductionCodeFileJS()
	local fileName = vim.fn.expand("%:t")
	local extension = vim.fn.expand("%:e")
	local testFileDir = vim.fn.expand("%:h")

	for _, ex in ipairs(FILE_EXTENSIONS) do
		local productionCodeFileName = fileName:gsub("%.spec%." .. extension .. "$", "%." .. ex)
		local productionCodeFileDir = testFileDir:gsub("__tests__", "")
		local result = productionCodeFileDir .. productionCodeFileName
		local isReadable = vim.fn.filereadable(result) ~= 0

		if isReadable then
			return result
		end
	end

	local productionCodeFileName = fileName:gsub("%.spec%." .. extension .. "$", "%." .. extension)
	local productionCodeFileDir = testFileDir:gsub("__tests__", "")

	return productionCodeFileDir .. productionCodeFileName
end

function ToggleJsFile()
	if isTestFileJs() then
		vim.cmd("e " .. getProductionCodeFileJS())
	else
		vim.cmd("e " .. getTestFileJs())
	end
end
