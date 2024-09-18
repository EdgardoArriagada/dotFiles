local configServers = {
	pyright = {},
	--[[ gleam = {}, ]]
	cssls = {},
	emmet_language_server = {},
	tailwindcss = {},
	bashls = {},
	gopls = {},
	rust_analyzer = {},
	lua_ls = {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim", "hs", "table" },
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

local serverNames = {}

for server, _ in pairs(configServers) do
	if server ~= "ts_ls" then
		table.insert(serverNames, server)
	end
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
				ensure_installed = serverNames,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "InsertEnter",
		config = function()
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			local on_attach = function(_, buffer)
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
