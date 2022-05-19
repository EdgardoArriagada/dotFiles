----------
local theme = 'gruvbox'
----------

local colorscheme = 'colorscheme ' .. theme

safeCall(vim.cmd, colorscheme, function() 
  vim.notify(colorscheme .. ' not found!')
  vim.cmd [[colorscheme default]]
end)
