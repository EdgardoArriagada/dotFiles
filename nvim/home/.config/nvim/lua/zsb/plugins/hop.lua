return {
	"phaazon/hop.nvim",
	branch = "v1", -- optional but strongly recommended
	keys = "s",
	config = function()
		Hpcall(require, "hop", {
			onOk = function(hop)
				hop.setup({ keys = "etovxqpdygfblzhckisuran" })
			end,
			onErr = "Failed to setup hop",
		})

		keymap.set("n", "s", function()
			require("hop").hint_char2()
		end, { noremap = false, silent = true })
	end,
}
