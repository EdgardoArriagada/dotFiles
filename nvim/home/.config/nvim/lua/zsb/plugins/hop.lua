return {
	"smoka7/hop.nvim",
	version = "*",
	keys = "s",
	config = Config("hop", function(hop)
		hop.setup({ keys = "etovxqpdygfblzhckisuran" })

		Kset("n", "s", function()
			require("hop").hint_char2()
		end, { noremap = false, silent = true })
	end),
}
