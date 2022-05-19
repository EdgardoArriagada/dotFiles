----------
local theme = 'gruvbox'
----------

local colorscheme = 'colorscheme ' .. theme

local ok, _ = pcall(vim.cmd, colorscheme)

if not ok then
  vim.notify(colorscheme .. ' not found!')
  vim.cmd [[colorscheme default]]
  return
end
