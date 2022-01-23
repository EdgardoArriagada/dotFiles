require('utils')
local o = vim.o
local wo = vim.wo
local bo = vim.bo

-- map the leader key
vim.api.nvim_set_keymap('n', '<Space>', '', {})
vim.g.mapleader = ' '  -- 'vim.g' sets global variables

vim.o.clipboard = "unnamedplus"

-- TODO: paste without yanking
-- vnoremap('ap' "'$hpgv\"'.v:register.'y`>'")
-- xnoremap <expr> p 'pgv"'.v:register.'y`>'
-- xnoremap <expr> P 'Pgv"'.v:register.'y`>'

-- global options
o.swapfile = true
o.dir = '/tmp'
o.smartcase = true
o.laststatus = 2
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.scrolloff = 12
-- ... snip ...

-- window-local options
wo.number = true
wo.wrap = false

-- buffer-local options
bo.expandtab = true


vnoremap('w', 'iw')
