local configServers = {
	pyright = {},
	--[[ gleam = {}, ]]
	cssls = {},
	emmet_language_server = {},
	tailwindcss = {},
	bashls = {},
	gopls = {},
	rust_analyzer = {},
	lua_ls = {},
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
	-- Conform will run multiple formatters sequentially
	python = { "isort", "black" },
	-- You can customize some of the format options for the filetype (:help conform.format)
	rust = { "rustfmt", lsp_format = "fallback" },
	-- Conform will run the first available formatter
	javascript = jsFormatter,
	typescript = jsFormatter,
	javascriptreact = jsFormatter,
	typescriptreact = jsFormatter,
	json = jsFormatter,
	elixir = { "mix" },
}

local serverNames = {}
for server, _ in pairs(configServers) do
	if server ~= "ts_ls" then
		table.insert(serverNames, server)
	end
end

return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufWritePost", "TextChanged" },
		config = Config("lint", function(plugin)
			local jsLinter = { "eslint_d" }

			plugin.linters_by_ft = {
				python = { "flake8" },
				javascript = jsLinter,
				typescript = jsLinter,
				javascriptreact = jsLinter,
				typescriptreact = jsLinter,
				json = { "jsonlint" },
				lua = { "luacheck" },
				rust = { "rustc" },
				elixir = { "mix" },
			}
			Cautocmd({ "BufWritePost", "TextChanged" }, {
				callback = function()
					require("lint").try_lint()
				end,
				group = Group,
			})
		end),
	},
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
				ensure_installed = serverNames,
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
