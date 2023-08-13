return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		Hpcall(require, "nvim-autopairs", {
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

		Hpcall(require, "nvim-autopairs.completion.cmp", {
			onOk = function(cmp_autopairs)
				Hpcall(require, "cmp", {
					onOk = function(cmp)
						cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
					end,
					onErr = "failed to setup cmp",
				})
			end,
			onErr = "failed to setup nvim-autopairs.completion.cmp",
		})
	end,
}
