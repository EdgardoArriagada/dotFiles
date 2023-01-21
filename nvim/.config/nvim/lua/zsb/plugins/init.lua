return {
  {'nvim-treesitter/nvim-treesitter', build=':TSUpdate'},
  {'windwp/nvim-ts-autotag', dependencies = {'nvim-treesitter/nvim-treesitter'}},
	{'nvim-telescope/telescope-fzf-native.nvim', build ='make'},
}
