local function isTestFileJs(fileName, extension)
	return string.match(fileName, "%.spec%." .. extension .. "$")
end

local function getTestFileJs(fileName, extension)
	local fileDir = vim.fn.expand("%:h")

	local testFileName = fileName:gsub("%." .. extension .. "$", "%.spec%." .. extension)

	return fileDir .. "/__tests__/" .. testFileName
end

local function getProductionCodeFileJS(fileName, extension)
	local testFileDir = vim.fn.expand("%:h")

	local productionCodeFileName = fileName:gsub("%.spec%." .. extension .. "$", "%." .. extension)
	local productionCodeFileDir = testFileDir:gsub("__tests__", "")

	return productionCodeFileDir .. productionCodeFileName
end

function toggleJsFile()
	local fileName = vim.fn.expand("%:t")
	local extension = vim.fn.expand("%:e")

	if isTestFileJs(fileName, extension) then
		vim.cmd("e " .. getProductionCodeFileJS(fileName, extension))
	else
		vim.cmd("e " .. getTestFileJs(fileName, extension))
	end
end
