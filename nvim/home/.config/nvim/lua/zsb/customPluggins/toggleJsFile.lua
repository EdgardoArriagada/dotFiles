local JS_EXTENSIONS = {
	"ts",
	"tsx",
	"js",
	"jsx",
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
	local ft = vim.fn.expand("%:e")

	for _, ex in ipairs(JS_EXTENSIONS) do
		local newExtension = a.newExtensionPrefix .. ex
		local fileName = vim.fn.expand("%:t"):gsub(a.oldExtension .. "$", newExtension)
		local result = a.newFileDir .. fileName

		if doesFileExists(result) then
			return result
		end

		if ft == ex then
			fallback = result
		end
	end

	return fallback
end

local function getTestFile()
	return findFile({
		newFileDir = vim.fn.expand("%:h") .. "/__tests__/",
		oldExtension = "%." .. vim.fn.expand("%:e"),
		newExtensionPrefix = "%.spec%.",
	})
end

local function getProductionCodeFile()
	return findFile({
		newFileDir = vim.fn.expand("%:h"):gsub("__tests__", ""),
		oldExtension = "%.spec%." .. vim.fn.expand("%:e"),
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
