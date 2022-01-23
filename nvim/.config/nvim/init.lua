local o = vim.o
local wo = vim.wo
local bo = vim.bo
local map = vim.api.nvim_set_keymap

function vnoremap (a, b)
  map('v', a, b, { noremap = true })
end

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
wo.number = false
wo.wrap = false

-- buffer-local options
bo.expandtab = true

-- map the leader key
map('n', '<Space>', '', {})
vim.g.mapleader = ' '  -- 'vim.g' sets global variables

vnoremap('w', 'iw')
