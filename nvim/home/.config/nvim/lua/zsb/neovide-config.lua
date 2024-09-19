local set_keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

local autocmd = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("TelescopePreview", { clear = true })

local ANIMATION_LENGTH = 0.6

vim.g.neovide_scroll_animation_length = ANIMATION_LENGTH

autocmd("FileType", {
	pattern = "TelescopePreview",
	callback = function()
		vim.g.neovide_scroll_animation_length = 0
	end,
	group = group,
})

autocmd("BufLeave", {
	pattern = "TelescopePreview",
	callback = function()
		vim.g.neovide_scroll_animation_length = ANIMATION_LENGTH
	end,
	group = group,
})
-- Allow clipboard copy paste in neovim
vim.g.neovide_input_use_logo = 1

vim.opt.clipboard = "unnamedplus"

set_keymap("", "<D-v>", "+p<CR>", opts)
set_keymap("!", "<D-v>", "<C-R>+", opts)
set_keymap("t", "<D-v>", "<C-R>+", opts)
set_keymap("v", "<D-v>", "<C-R>+", opts)
