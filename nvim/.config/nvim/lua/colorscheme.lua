if vim.g.vscode then return end

----------
local theme = 'vscode'
vim.g.vscode_style = "dark"
vim.g.vscode_transparent = 1
vim.g.vscode_italic_comment = 1
vim.g.vscode_disable_nvimtree_bg = true
----------

local colorscheme = 'colorscheme ' .. theme

withFallback(vim.cmd, colorscheme, function() 
  vim.notify(colorscheme .. ' not found!')
  vim.cmd [[colorscheme default]]
end)
