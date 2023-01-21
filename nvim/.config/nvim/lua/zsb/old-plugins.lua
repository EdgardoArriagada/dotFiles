function pluginsStartup(use)
	use("wbthomason/packer.nvim") -- Have packer manage itself

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
