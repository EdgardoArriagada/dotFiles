keymap.set("n", "<C-p>", function()
  require("telescope.builtin").git_files()
end)
