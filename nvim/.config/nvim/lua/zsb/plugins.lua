function pluginsStartup(use)
  use 'wbthomason/packer.nvim' -- Have packer manage itself

  -- Hop
  use {
    'phaazon/hop.nvim',
    branch = 'v1', -- optional but strongly recommended
    config = function() require('zsb.setup.hop') end,
  }

  -- Comments
  use {
    'numToStr/Comment.nvim',
    config = function() require('zsb.setup.comment') end,
  }
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  -- NVIM ONLY PLUGGINS -- (manually skip if in vscode in each config function/file)

  -- Common plugins
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use 'moll/vim-bbye'

  -- Auto pairs
  use {
    'windwp/nvim-autopairs',
    config = function() require('zsb.setup.nvim-autopairs') end,
  }

  -- NvimTree
  use {
    'kyazdani42/nvim-tree.lua',
    tag = 'nightly', -- optional, updated every week. (see issue #1193)
    config = function() require('zsb.setup.nvim-tree') end,
  }

  -- Bufferline
  use {
    'akinsho/bufferline.nvim',
    config = function() require('zsb.setup.bufferline') end,
  }

  -- Whichkey
  use {
    "max397574/which-key.nvim",
    config = function()
      require("zsb.setup.which-key")
    end,
    event = "BufWinEnter",
  }

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
  use {
    'jose-elias-alvarez/null-ls.nvim',
    config = function() require('zsb.setup.null-ls') end,
  }

  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    config = function() require('zsb.setup.telescope') end,
  }

  -- Treesitteer
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }
  use 'windwp/nvim-ts-autotag'

  -- Git
  use {
    'lewis6991/gitsigns.nvim',
    config = function() require('zsb.setup.gitsigns') end,
  }

  use 'p00f/nvim-ts-rainbow'

  -- Scroll
  use {
    'karb94/neoscroll.nvim',
    config = function() require('zsb.setup.neoscroll') end,
  }

  -- Looks
  use "ellisonleao/gruvbox.nvim"
end
