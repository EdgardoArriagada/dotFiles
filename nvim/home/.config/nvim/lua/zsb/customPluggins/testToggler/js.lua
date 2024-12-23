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

local function findFile(a)
	local fallback
	local filename = vim.fn.expand("%:t")
	local ft = vim.fn.expand("%:e")
	local endFile = a.oldExtensionPrefix .. ft .. "$"

	for i, iFt in ipairs(JS_FILE_RELATIONS[ft]) do
		local newFilename = filename:gsub(endFile, a.newExtensionPrefix .. iFt)
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

---@type ZsbTestToggler
return {
	isTestFile = function()
		local fileName = vim.fn.expand("%:t")
		local ft = vim.fn.expand("%:e")

		return string.find(fileName, "%.spec%." .. ft .. "$")
	end,

	getTestFile = function()
		return findFile({
			newFileDir = vim.fn.expand("%:h") .. "/__tests__/",
			oldExtensionPrefix = "%.",
			newExtensionPrefix = "%.spec%.",
		})
	end,

	getProductionCodeFile = function()
		return findFile({
			newFileDir = vim.fn.expand("%:h"):gsub("__tests__", ""),
			oldExtensionPrefix = "%.spec%.",
			newExtensionPrefix = "%.",
		})
	end,
}
