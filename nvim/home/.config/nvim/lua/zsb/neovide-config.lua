local group = vim.api.nvim_create_augroup("TelescopePreview", { clear = true })

local ANIMATION_LENGTH = 0.6

vim.g.neovide_scroll_animation_length = ANIMATION_LENGTH

Cautocmd("FileType", {
	pattern = "TelescopePreview",
	callback = function()
		vim.g.neovide_scroll_animation_length = 0
	end,
	group = group,
})

Cautocmd("BufLeave", {
	pattern = "TelescopePreview",
	callback = function()
		vim.g.neovide_scroll_animation_length = ANIMATION_LENGTH
	end,
	group = group,
})
-- Allow clipboard copy paste in neovim
vim.g.neovide_input_use_logo = 1

vim.opt.clipboard = "unnamedplus"

Kset("", "<D-v>", "+p<CR>")
Kset("!", "<D-v>", "<C-R>+")
Kset("t", "<D-v>", "<C-R>+")
Kset("v", "<D-v>", "<C-R>+")
