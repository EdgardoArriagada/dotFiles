function pluginsStartup(use)
  use 'wbthomason/packer.nvim' -- Have packer manage itself

  -- Common plugins
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'

  -- Completion plugins https://github.com/topics/nvim-cmp
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  -- Snippets
  use 'L3MON4D3/LuaSnip'

  -- Lsp
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'

  -- Telescope
  use {
      "nvim-telescope/telescope.nvim",
      module = "telescope",
      cmd = "Telescope",
  }

  -- Treesitteer
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }
  use 'p00f/nvim-ts-rainbow'

  -- Looks
  use 'gruvbox-community/gruvbox'
end
