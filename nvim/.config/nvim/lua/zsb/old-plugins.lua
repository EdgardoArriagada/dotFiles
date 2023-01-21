function pluginsStartup(use)
	use("wbthomason/packer.nvim") -- Have packer manage itself

	-- NVIM ONLY PLUGGINS -- (manually skip if in vscode in each config function/file)

	-- Common plugins
	use("nvim-lua/popup.nvim")
	use("nvim-lua/plenary.nvim")
	use("kyazdani42/nvim-web-devicons")
	use("moll/vim-bbye")


	-- Refactoring
	use({
		"ThePrimeagen/refactoring.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
		config = function()
			require("zsb.setup.refactoring")
		end,
	})

	use({
		"napmn/react-extract.nvim",
		config = function()
			require("react-extract").setup()
		end,
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	})

	-- Auto pairs
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("zsb.setup.nvim-autopairs")
		end,
	})

	-- Bufferline
	use({
		"akinsho/bufferline.nvim",
		config = function()
			require("zsb.setup.bufferline")
		end,
	})


	-- Lsp
	use("neovim/nvim-lspconfig")
	use("williamboman/nvim-lsp-installer")
	use({
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			require("zsb.setup.null-ls")
		end,
	})

	-- Harpoon
	use("ThePrimeagen/harpoon")


	-- Multiple Cursors
	use("mg979/vim-visual-multi")


	-- Git
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("zsb.setup.gitsigns")
		end,
	})

	use({
		"p00f/nvim-ts-rainbow",
		config = function()
			require("zsb.setup.nvim-ts-rainbow")
		end,
	})

	--Copilot
	use("github/copilot.vim")


	-- Transparency
	use({
		"xiyaowong/nvim-transparent",
		config = function()
			require("zsb.setup.nvim-transparent")
		end,
	})

	-- Vertical lines
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("zsb.setup.indent-blankline")
		end,
	})

	-- Status line
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
			require("zsb.setup.lualine")
		end,
	})

	-- Folding
	use({
		"anuvyklack/pretty-fold.nvim",
		config = function()
			require("zsb.setup.pretty-fold")
		end,
		ft = { "json" },
	})

	-- Markdown
	use({
		"ekickx/clipboard-image.nvim",
		ft = { "markdown" },
	})

	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	})
end
