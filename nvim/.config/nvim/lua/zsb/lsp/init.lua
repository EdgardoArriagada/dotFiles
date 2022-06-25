if not vim.g.vscode then return end

whenOk(require, 'zsb.lspConfig', function()
  require("zsb.lsp.configs")
  require("zsb.lsp.handlers").setup()
  require("zsb.lsp.null-ls")
end)
