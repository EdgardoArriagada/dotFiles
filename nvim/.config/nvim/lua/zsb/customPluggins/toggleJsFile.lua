local function isTestFileJs()
	local fileName = vim.fn.expand("%:t")
	local extension = vim.fn.expand("%:e")

	return string.match(fileName, "%.spec%." .. extension .. "$")
end

local function getTestFileJs()
	local fileName = vim.fn.expand("%:t")
	local extension = vim.fn.expand("%:e")
	local fileDir = vim.fn.expand("%:h")

	local testFileName = fileName:gsub("%." .. extension .. "$", "%.spec%." .. extension)

	return fileDir .. "/__tests__/" .. testFileName
end

local function getProductionCodeFileJS()
	local fileName = vim.fn.expand("%:t")
	local extension = vim.fn.expand("%:e")
	local testFileDir = vim.fn.expand("%:h")

	local productionCodeFileName = fileName:gsub("%.spec%." .. extension .. "$", "%." .. extension)
	local productionCodeFileDir = testFileDir:gsub("__tests__", "")

	return productionCodeFileDir .. productionCodeFileName
end

function toggleJsFile()
	if isTestFileJs() then
		vim.cmd("e " .. getProductionCodeFileJS())
	else
		vim.cmd("e " .. getTestFileJs())
	end
end
