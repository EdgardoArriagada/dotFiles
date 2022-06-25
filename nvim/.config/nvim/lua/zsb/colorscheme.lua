if vim.g.vscode then return end

-- Change here --
---------- -------- -------- --------
local theme = 'gruvbox'
vim.opt.background = 'dark' -- or "light" for light mode
---------- -------- -------- --------

local colorCmd = 'colorscheme ' .. theme

withFallback(vim.cmd, colorCmd, function() 
  vim.notify(colorCmd .. ' not found!')
  vim.cmd [[colorscheme default]]
end)
