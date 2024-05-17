local JS_EXTENSIONS = {
	"js",
	"jsx",
	"ts",
	"tsx",
}

local function doesFileExists(file)
	return vim.fn.filereadable(file) ~= 0
end

local function isTestFile()
	local fileName = vim.fn.expand("%:t")
	local ft = vim.fn.expand("%:e")

	return string.match(fileName, "%.spec%." .. ft .. "$")
end

local function getTestFile()
	local fileName = vim.fn.expand("%:t")
	local ft = vim.fn.expand("%:e")
	local testDir = vim.fn.expand("%:h") .. "/__tests__/"
	local endFile = "%." .. ft .. "$"
	local fallback

	for _, ex in ipairs(JS_EXTENSIONS) do
		local extension = "%.spec%." .. ex
		local testFileName = fileName:gsub(endFile, extension)
		local result = testDir .. testFileName

		if doesFileExists(result) then
			return result
		end

		if ft == ex then
			fallback = result
		end
	end

	return fallback
end

local function getProductionCodeFile()
	local testFileName = vim.fn.expand("%:t")
	local ft = vim.fn.expand("%:e")
	local testFileDir = vim.fn.expand("%:h")
	local fileDir = testFileDir:gsub("__tests__", "")
	local endFile = "%.spec%." .. ft .. "$"
	local fallback

	for _, ex in ipairs(JS_EXTENSIONS) do
		local extension = "%." .. ex
		local fileName = testFileName:gsub(endFile, extension)
		local result = fileDir .. fileName

		if doesFileExists(result) then
			return result
		end

		if ft == ex then
			fallback = result
		end
	end

	return fallback
end

function ToggleJsFile()
	if isTestFile() then
		vim.cmd("e " .. getProductionCodeFile())
	else
		vim.cmd("e " .. getTestFile())
	end
end
