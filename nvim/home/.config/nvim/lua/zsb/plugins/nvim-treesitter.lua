local parsers = { "lua", "vim", "vimdoc", "query", "graphql", "regex" }
local disabled_filetypes = { diff = true }

local function should_start_treesitter(bufnr)
	local filetype = vim.bo[bufnr].filetype

	if disabled_filetypes[filetype] then
		return false
	end

	return HasBufCorrectSize(bufnr)
end

local function start_treesitter(args)
	if not should_start_treesitter(args.buf) then
		return
	end

	pcall(vim.treesitter.start, args.buf)
end

local function sync_parsers()
	local treesitter = require("nvim-treesitter")

	assert(treesitter.install(parsers):wait(300000), "failed to install Treesitter parsers")
	assert(treesitter.update(parsers):wait(300000), "failed to update Treesitter parsers")
end

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = sync_parsers,
	config = function()
		local treesitter = require("nvim-treesitter")

		treesitter.setup()

		local group = vim.api.nvim_create_augroup("ZsbTreesitter", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			callback = start_treesitter,
		})
	end,
}
