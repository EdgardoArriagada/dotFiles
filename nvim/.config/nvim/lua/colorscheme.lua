if vim.g.vscode then return end

----------
local theme = 'gruvbox'
vim.opt.background = 'dark' -- or "light" for light mode
----------

local colorscheme = 'colorscheme ' .. theme

withFallback(vim.cmd, colorscheme, function() 
  vim.notify(colorscheme .. ' not found!')
  vim.cmd [[colorscheme default]]
end)
