if vim.g.vscode then return end

keymap.set('n', 'Q', ':Bdelete<Cr>')
keymap.set("n", "<tab>", ':BufferLineCycleNext<Cr>')
keymap.set("n", "<S-tab>", ':BufferLineCyclePrev<Cr>')