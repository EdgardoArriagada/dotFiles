require("zsb.plugins")

local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap =
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

hpcall(require, "packer", {
	onOk = function(packer)
		-- Have packer use a popup window
		packer.init({
			display = {
				open_fn = function()
					return require("packer.util").float({ border = "rounded" })
				end,
			},
		})

		packer.startup(function(use)
			pluginsStartup(use)

			-- Automatically set up your configuration after cloning packer.nvim
			-- Put this at the end after all plugins
			if packer_bootstrap then
				require("packer").sync()
			end
		end)
	end,
})
