-- firt element has to be itself
local JS_FILE_RELATIONS = {
	["ts"] = { "ts", "tsx" },
	["tsx"] = { "tsx", "ts" },
	["js"] = { "js", "jsx" },
	["jsx"] = { "jsx", "js" },
}

local function doesFileExists(file)
	return vim.fn.filereadable(file) ~= 0
end

local function isTestFile()
	local fileName = vim.fn.expand("%:t")
	local ft = vim.fn.expand("%:e")

	return string.match(fileName, "%.spec%." .. ft .. "$")
end

local function findFile(a)
	local fallback
	local filename = vim.fn.expand("%:t")
	local ft = vim.fn.expand("%:e")
	local endFile = a.oldExtensionPrefix .. ft .. "$"

	for i, ex in ipairs(JS_FILE_RELATIONS[ft]) do
		local newExtension = a.newExtensionPrefix .. ex
		local newFilename = filename:gsub(endFile, newExtension)
		local result = a.newFileDir .. newFilename

		if doesFileExists(result) then
			return result
		end

		if i == 1 then
			fallback = result
		end
	end

	return fallback
end

local function getTestFile()
	return findFile({
		newFileDir = vim.fn.expand("%:h") .. "/__tests__/",
		oldExtensionPrefix = "%.",
		newExtensionPrefix = "%.spec%.",
	})
end

local function getProductionCodeFile()
	return findFile({
		newFileDir = vim.fn.expand("%:h"):gsub("__tests__", ""),
		oldExtensionPrefix = "%.spec%.",
		newExtensionPrefix = "%.",
	})
end

function ToggleJsFile()
	if isTestFile() then
		vim.cmd("e " .. getProductionCodeFile())
	else
		vim.cmd("e " .. getTestFile())
	end
end
