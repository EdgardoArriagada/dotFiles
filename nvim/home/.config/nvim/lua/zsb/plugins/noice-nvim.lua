return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		config = function()
			local noice = require("noice")

			noice.setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					signature = {
						enabled = false,
					},
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = false, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
				messages = {
					-- NOTE: If you enable messages, then the cmdline is enabled automatically.
					-- This is a current Neovim limitation.
					enabled = true, -- enables the Noice messages UI
					view = "notify", -- default view for messages
					view_error = "notify", -- view for errors
					view_warn = "notify", -- view for warnings
					view_search = false, -- view for search count messages. Set to `false` to disable
				},
				routes = {
					{
						filter = {
							event = "msg_show",
							kind = "",
						},
						opts = { skip = true },
					},
					{
						filter = {
							event = "notify",
							find = "No information available",
						},
						opts = { skip = true },
					},
					{
						view = "notify",
						filter = { event = "msg_showmode" }, -- show recording macro
					},
				},
			})

			kset("n", "!", function()
				noice.cmd("dismiss")
			end, { noremap = true, silent = true })
		end,
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},
	{
		"rcarriga/nvim-notify",
		lazy = true,
		opts = {
			stages = "static", -- prefent cursor from flickering
			timeout = 3000,
		},
	},
}
