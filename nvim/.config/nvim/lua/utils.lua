local map = vim.api.nvim_set_keymap

local noremapOption = { noremap = true }

function vnoremap(a, b)
  map('v', a, b, noremapOption)
end

function xnoremap(a, b)
  map('x', a, b, noremapOption)
end

