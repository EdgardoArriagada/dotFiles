--[[ if vim.g.vscode then return end ]]

keymap.set("n", "Q", ":Bdelete<Cr>")
keymap.set("n", "<S-l>", ":BufferLineCycleNext<Cr>")
keymap.set("n", "<S-h>", ":BufferLineCyclePrev<Cr>")
