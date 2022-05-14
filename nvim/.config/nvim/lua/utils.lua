local _map = vim.api.nvim_set_keymap

local noremapOption = { noremap = true }

function vnoremap(a, b)
  _map('v', a, b, noremapOption)
end

function xnoremap(a, b)
  _map('x', a, b, noremapOption)
end

