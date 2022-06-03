local km = vim.keymap

-- map the leader key
map('n', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleade= ' '

-- Shorcuts
map('o', 'w', 'iw')
map('o', 'W', 'iW')
map('o', '{', 'i{')
map('o', '}', 'i}')
map('o', '(', 'i(')
map('o', ')', 'i)')
--
map('v', 'w', 'iw')
map('v', 'W', 'iW')
map('v', '{', 'i{')
map('v', '}', 'i}')
map('v', '(', 'i(')
map('v', ')', 'i)')
map('v', 'R', 'loh')
--

map('n', 'Y', 'y$')
map('n', 'S', 'v$<left><left>')
map('n', '+', 'A <esc>p')
-- Swapping: delete some text, then visual select other text, execute the maped
-- key and the swap is made
map('v', '+', '<Esc>`.``gvP``P')
--Duplicate selection
map('v', 'Z', '"xy\'>"xpO<esc>')

-- You can trigger 'vap' 'vay' 'vad'
map('v', 'aa', '$<left>')
map('v', 'ay', '$<left>y')
map('v', 'ad', '$<left>d')
map('v', 'as', '$<left>s')
map('v', 'ac', '$<left>c')
-- (special case: avoid yanking)
map('v', 'ap', '\'$hpgv"\'.v:register.\'y`>\'', { expr = true })

-- Paste many times over selected text without yanking it
map('x', 'p', '\'pgv"\'.v:register.\'y`>\'', { expr = true })
map('x', 'P', '\'Pgv"\'.v:register.\'y`>\'', { expr = true })

-- Go and trim visual selection
map('v', 'gt', ':s/\\s\\+/ /g<CR>')

map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
map('n', 'J', 'mzJ`z')

-- Undo checkpoints
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', '!', '!<c-g>u')
map('i', '[', '[<c-g>u')
map('i', ']', ']<c-g>u')
map('i', '{', '{<c-g>u')
map('i', '}', '}<c-g>u')
map('i', '"', '"<c-g>u')
map('i', '\'', '\'<c-g>u')
map('i', '<', '<<c-g>u')
map('i', '>', '><c-g>u')
map('i', '<Space>', '<Space><c-g>u')

-- Quit
map('n', '<C-q>', ':q')

-- Save
map('n', '<C-s>', ':update<CR>', { silent = true })
map('v', '<C-s>', '<esc>:update<CR>', { silent = true })
map('i', '<C-s>', '<esc>:update<CR>', { silent = true })

--Search and replace matches for highlighted text
map('v', '<C-r>', '"hy:.,$s/<C-r>h//gc<left><left><left>')
-- Move highlighted text down 'Shift j'
map('v', 'J', ':m \'>+1<CR>gv=gv')
-- Move highlighted text up 'Shift k'
map('v', 'K', ':m \'<-2<CR>gv=gv')

-- Add moves of more than 5 to the jump list
km.set("n", "k", [[(v:count > 5 ? "m'" . v:count : "") . 'k']], { expr = true, desc = "if k > 5 then add to jumplist" })
km.set("n", "j", [[(v:count > 5 ? "m'" . v:count : "") . 'j']], { expr = true, desc = "if j > 5 then add to jumplist" })

-- Telescope
km.set("n", "<C-p>", function()
  require("telescope.builtin").git_files()
end)
km.set("n", "<leader>r", function()
  require("telescope.builtin").registers()
end)
km.set("n", "<leader>g", function()
  require("telescope.builtin").live_grep()
end)
km.set("n", "<leader>b", function()
  require("telescope.builtin").buffers()
end)
km.set("n", "<leader>j", function()
  require("telescope.builtin").help_tags()
end)
km.set("n", "<leader>h", function()
  require("telescope.builtin").git_bcommits()
end)
km.set("n", "<leader>f", function()
  require("telescope").extensions.file_browser.file_browser()
end)
km.set("n", "<leader>s", function()
  require("telescope.builtin").spell_suggest()
end)
km.set("n", "<leader>i", function()
  require("telescope.builtin").git_status()
end)
km.set("n", "<leader>ca", function()
  require("telescope.builtin").lsp_code_actions()
end)
km.set("n", "<leader>cs", function()
  require("telescope.builtin").lsp_document_symbols()
end)
km.set("n", "<leader>cd", function()
  require("telescope.builtin").lsp_document_diagnostics()
end)
km.set("n", "<leader>cr", function()
  require("telescope.builtin").lsp_references()
end)
km.set({ "v", "n" }, "<leader>cn", function()
  vim.lsp.buf.rename()
end, { noremap = true, silent = true })
km.set("n", "<leader>ci", function()
  vim.diagnostic.open_float()
end)

