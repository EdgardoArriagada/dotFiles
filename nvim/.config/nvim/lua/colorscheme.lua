----------
local theme = 'gruvbox'
----------

local colorscheme = 'colorscheme ' .. theme

withFallback(vim.cmd, colorscheme, function() 
  vim.notify(colorscheme .. ' not found!')
  vim.cmd [[colorscheme default]]
end)
