return {
	"phaazon/hop.nvim",
	branch = "v1", -- optional but strongly recommended
	opts = { keys = "etovxqpdygfblzhckisuran" },
	keys = function()
		keymap.set("n", "s", function()
			require("hop").hint_char2()
		end, { noremap = false, silent = true })
	end,
}
