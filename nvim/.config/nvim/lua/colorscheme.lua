local colorscheme = 'gruvbox'

local colorschemeCmd = 'colorscheme ' .. colorscheme

local ok, _ = pcall(vim.cmd, colorschemeCmd)

if not ok then
  vim.notify(colorschemeCmd .. 'not found')
  vim.cmd [[colorscheme default]]
  return
end
