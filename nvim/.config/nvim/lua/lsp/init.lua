if not vim.g.vscode then return end

whenOk(require, 'lspConfig', function()
  require("lsp.configs")
  require("lsp.handlers").setup()
  require("lsp.null-ls")
end)
