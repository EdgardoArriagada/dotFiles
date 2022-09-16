--[[ if vim.g.vscode then return end ]]

-- Setup nvim-cmp.
hpcall(require, "nvim-autopairs", {
	onOk = function(npairs)
		npairs.setup({
			check_ts = true,
			ts_config = {
				lua = { "string", "source" },
				javascript = { "string", "template_string" },
				java = false,
			},
			disable_filetype = { "TelescopePrompt", "spectre_panel" },
			fast_wrap = {
				map = "<M-e>",
				chars = { "{", "[", "(", '"', "'" },
				pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
				offset = 0, -- Offset from pattern match
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "PmenuSel",
				highlight_grey = "LineNr",
			},
		})
	end,
	onErr = "failed to setup nvim-autopairs",
})

hpcall(require, "nvim-autopairs.completion.cmp", {
	onOk = function(cmp_autopairs)
		hpcall(require, "cmp", {
			onOk = function(cmp)
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
			end,
			onErr = "failed to setup cmp",
		})
	end,
	onErr = "failed to setup nvim-autopairs.completion.cmp",
})
