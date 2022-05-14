function pluginsStartup(use)
  use 'wbthomason/packer.nvim' -- Have packer manage itself
  use({
      "nvim-telescope/telescope.nvim",
      module = "telescope",
      cmd = "Telescope",
      requires = {
        { "nvim-lua/popup.nvim" },
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      },
  })

  -- Looks
  use 'gruvbox-community/gruvbox'
end
