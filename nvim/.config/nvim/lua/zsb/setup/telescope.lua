keymap.set("n", "<C-p>", function()
  require("telescope.builtin").git_files()
end)

keymap.set("n", "<leader>pa", function()
  require("telescope.builtin").find_files()
end)

keymap.set("n", "<leader>pf", function()
  require("telescope.builtin").grep_string({ search = vim.fn.input("Grep For > ")})
end)

keymap.set("n", "<leader>pl", function()
  require("telescope.builtin").live_grep()
end)

keymap.set("n", "<leader>pb", function()
  require("telescope.builtin").file_browser()
end)
