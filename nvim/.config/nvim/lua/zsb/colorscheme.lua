if vim.g.vscode then return end

-- Change here --
---------- -------- -------- --------
local theme = 'gruvbox-flat'
vim.g.gruvbox_flat_style = "dark"
---------- -------- -------- --------

local colorCmd = 'colorscheme ' .. theme

withFallback(vim.cmd, colorCmd, function() 
  vim.notify(colorCmd .. ' not found!')
  vim.cmd [[colorscheme default]]
end)
