local global = vim.g
local set_keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.o.guifont = "Hack Nerd Font:h21"

global.neovide_scroll_animation_length = 0.6
global.neovide_fullscreen = true

-- Allow clipboard copy paste in neovim
global.neovide_input_use_logo = 1

set_keymap("", "<D-v>", "+p<CR>", opts)
set_keymap("!", "<D-v>", "<C-R>+", opts)
set_keymap("t", "<D-v>", "<C-R>+", opts)
set_keymap("v", "<D-v>", "<C-R>+", opts)
