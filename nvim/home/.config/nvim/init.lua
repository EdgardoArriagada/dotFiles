require("zsb.temp")
require("zsb.utils")
require("zsb.mappings")
require("zsb.commands")
require("zsb.plugins-bootstrap")
require("zsb.customPluggins")
require("zsb.options")
require("zsb.autocmd")

if vim.g.neovide then
	require("zsb.neovide-config")
end

--[[ require('zsb.vscode-config') ]]
