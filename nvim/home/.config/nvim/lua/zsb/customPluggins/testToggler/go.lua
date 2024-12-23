local function listCurrentDir(glob)
	return vim.fn.globpath(vim.fn.expand("%:h"), glob, true, true)
end

---@type ZsbTestToggler
return {
	isTestFile = function()
		local currentFile = vim.fn.expand("%:t")

		return string.find(currentFile, "_test.go$")
	end,

	getTestFile = function()
		local basename = vim.fn.expand("%:t"):match("^[^.]+")

		return vim.fn.expand("%:h") .. "/" .. basename .. "_test.go"
	end,

	getProductionCodeFile = function()
		local basename = vim.fn.expand("%:t"):gsub("_test.go$", "")

		local prodFile = listCurrentDir("*" .. basename .. ".*go")[1]

		if prodFile then
			return prodFile
		else
			return vim.fn.expand("%:h") .. "/" .. basename .. ".go"
		end
	end,
}
