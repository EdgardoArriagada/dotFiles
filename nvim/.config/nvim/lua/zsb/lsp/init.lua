local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("zsb.lsp.lsp-installer")
require("zsb.lsp.handlers").setup()
