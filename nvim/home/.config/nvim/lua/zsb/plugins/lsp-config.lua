local configServers = {
	pyright = {},
	--[[ gleam = {}, ]]
	elixirls = {
		-- download from https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#elixirls
		-- and put in $HOME/elixir-ls
		cmd = { vim.fn.expand("$HOME/elixir-ls/language_server.sh") },
	},
	jsonls = {},
	cssls = {},
	emmet_language_server = {
		filetypes = {
			"html",
			"css",
			"scss",
			"javascriptreact",
			"typescriptreact",
			"heex",
		},
	},
	tailwindcss = {
		filetypes = {
			"gohtml",
			"html",
			"heex",
			"markdown",
			"css",
			"scss",
			"javascriptreact",
			"typescriptreact",
			"elixir",
		},
		init_options = {
			userLanguages = {
				elixir = "phoenix-heex",
				heex = "phoenix-heex",
			},
		},
	},
	bashls = {},
	gopls = {},
	rust_analyzer = {},
	lua_ls = {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim", "hs", "table", "require", "pairs" },
				},
			},
		},
	},
	ts_ls = {
		commands = {
			OrganizeImports = {
				function()
					vim.lsp.buf.execute_command({
						command = "_typescript.organizeImports",
						arguments = { vim.api.nvim_buf_get_name(0) },
						title = "",
					})
				end,
				description = "Organize Imports",
			},
		},
	},
}

local jsFormatter = { "prettierd", "eslint_d" }
local formattersByFt = {
	lua = { "stylua" },
	python = { "black" },
	rust = { "rustfmt" },
	javascript = jsFormatter,
	typescript = jsFormatter,
	javascriptreact = jsFormatter,
	typescriptreact = jsFormatter,
	yaml = { "prettierd" },
	json = { "prettierd" },
	elixir = { "mix" },
	heex = { "mix" },
	markdown = { "prettierd" },
}

local jsLinter = { "eslint_d" }
local lintersByFt = {
	python = { "flake8" },
	javascript = jsLinter,
	typescript = jsLinter,
	javascriptreact = jsLinter,
	typescriptreact = jsLinter,
	json = { "jsonlint" },
	rust = { "rustc" },
	--  mix escript.install hex credo
	elixir = { "credo" },
	heex = { "credo" },
}

local ensureInstalledServers = {}
for server, _ in pairs(configServers) do
	if server ~= "ts_ls" then
		table.insert(ensureInstalledServers, server)
	end
end

local linterFileTypes = {}
for ft, _ in pairs(lintersByFt) do
	table.insert(linterFileTypes, ft)
end

return {
	{ -- Do not lazy load
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{ -- Do not lazy load
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = ensureInstalledServers,
				automatic_installation = true,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = formattersByFt,
		},
	},
	{
		"mfussenegger/nvim-lint",
		ft = linterFileTypes,
		config = Config("lint", function(plugin)
			plugin.linters_by_ft = lintersByFt

			Cautocmd({ "BufWritePost", "TextChanged" }, {
				callback = function()
					SetTimeout(function()
						require("lint").try_lint()
					end, 1000)
				end,
				group = Group,
			})
		end),
	},
	{
		"neovim/nvim-lspconfig",
		event = "InsertEnter",
		config = function()
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			local on_attach = function(client, buffer)
				local opts = { noremap = true, silent = true, buffer = buffer }

				Kset("n", "gD", vim.lsp.buf.declaration, opts)
				Kset("n", "go", vim.lsp.buf.definition, opts)
				Kset("n", "gd", function()
					vim.lsp.buf.definition({
						on_list = function(list)
							OpenFileInPosition(list.items[1])
						end,
					})
				end, opts)
				Kset("n", "gi", vim.lsp.buf.implementation, opts)
				Kset("n", "gk", vim.lsp.buf.signature_help, opts)
				Kset("n", "gr", vim.lsp.buf.references, opts)

				local callback
				if formattersByFt[vim.bo.filetype] then
					callback = function()
						require("conform").format({ bufnr = buffer })
					end
				elseif client.supports_method("textDocument/formatting") then
					callback = function()
						vim.lsp.buf.format({ bufnr = buffer, id = client.id })
					end
				end

				if callback then
					Cautocmd("BufWritePre", {
						buffer = buffer,
						callback = callback,
						group = Group,
					})
				end
			end

			local defaultSetUp = {
				on_attach = on_attach,
				capabilities = capabilities,
			}

			local lspconfig = require("lspconfig")

			for serverName, config in pairs(configServers) do
				lspconfig[serverName].setup(Extend(defaultSetUp, config))
			end

			-- special config for gleam
			lspconfig.gleam.setup(defaultSetUp)
		end,
	},
}
