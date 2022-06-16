keymap.set("n", "<C-p>", function()
  require("telescope.builtin").git_files()
end)

keymap.set("n", "<leader>r", function()
  require("telescope.builtin").registers()
end)

keymap.set("n", "<leader>g", function()
  require("telescope.builtin").live_grep()
end)

keymap.set("n", "<leader>b", function()
  require("telescope.builtin").buffers()
end)

keymap.set("n", "<leader>j", function()
  require("telescope.builtin").help_tags()
end)

keymap.set("n", "<leader>h", function()
  require("telescope.builtin").git_bcommits()
end)

keymap.set("n", "<leader>f", function()
  require("telescope").extensions.file_browser.file_browser()
end)

keymap.set("n", "<leader>s", function()
  require("telescope.builtin").spell_suggest()
end)

keymap.set("n", "<leader>i", function()
  require("telescope.builtin").git_status()
end)

keymap.set("n", "<leader>ca", function()
  require("telescope.builtin").lsp_code_actions()
end)

keymap.set("n", "<leader>cs", function()
  require("telescope.builtin").lsp_document_symbols()
end)

keymap.set("n", "<leader>cd", function()
  require("telescope.builtin").lsp_document_diagnostics()
end)

keymap.set("n", "<leader>cr", function()
  require("telescope.builtin").lsp_references()
end)

keymap.set({ "v", "n" }, "<leader>cn", function()
  vim.lsp.buf.rename()
end, { noremap = true, silent = true })

keymap.set("n", "<leader>ci", function()
  vim.diagnostic.open_float()
end)
