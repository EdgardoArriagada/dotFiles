if vim.g.vscode then return end

keymap.set("n", "<C-p>", function()
  require("telescope.builtin").git_files()
end)
