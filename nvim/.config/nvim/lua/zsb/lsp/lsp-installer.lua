local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

local getConf = {
  ['jsonls'] = function() return require("zsb.lsp.settings.jsonls") end,
  ['sumneko_lua'] = function() return require("zsb.lsp.settings.sumneko_lua") end,
  ['pyright'] = function() return require("zsb.lsp.settings.pyright") end,
}

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
	local opts = {
		on_attach = require("zsb.lsp.handlers").on_attach,
		capabilities = require("zsb.lsp.handlers").capabilities,
	}

  local config = getConf[server.name]
  local customOpts
  if config then
    customOpts = config()
  else
    customOpts = {}
  end

  opts = vim.tbl_deep_extend("force", customOpts, opts)

	-- This setup() function is exactly the same as lspconfig's setup function.
	-- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	server:setup(opts)
end)
