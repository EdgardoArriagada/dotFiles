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

local function findFile(a)
	local fallback
	local ft = vim.fn.expand("%:e")

	for _, ex in ipairs(JS_EXTENSIONS) do
		local newExtension = a.newExtensionPrefix .. ex
		local fileName = a.oldFileName:gsub(a.oldExtension .. "$", newExtension)
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
	local ft = vim.fn.expand("%:e")

	return findFile({
		newFileDir = vim.fn.expand("%:h") .. "/__tests__/",
		oldFileName = vim.fn.expand("%:t"),
		oldExtension = "%." .. ft,
		newExtensionPrefix = "%.spec%.",
	})
end

local function getProductionCodeFile()
	local ft = vim.fn.expand("%:e")

	return findFile({
		newFileDir = vim.fn.expand("%:h"):gsub("__tests__", ""),
		oldFileName = vim.fn.expand("%:t"),
		oldExtension = "%.spec%." .. ft,
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
