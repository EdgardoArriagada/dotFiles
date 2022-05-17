function pluginsStartup(use)
  use 'wbthomason/packer.nvim' -- Have packer manage itself
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'

  use({
      "nvim-telescope/telescope.nvim",
      module = "telescope",
      cmd = "Telescope",
  })

  -- Looks
  use 'gruvbox-community/gruvbox'
end
