return {
	"phaazon/hop.nvim",
	branch = "v1", -- optional but strongly recommended
	keys = "s",
	config = Config("hop", function(hop)
		hop.setup({ keys = "etovxqpdygfblzhckisuran" })

		Kset("n", "s", function()
			require("hop").hint_char2()
		end, { noremap = false, silent = true })
	end),
}
