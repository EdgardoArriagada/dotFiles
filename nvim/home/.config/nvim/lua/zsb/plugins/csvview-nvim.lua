return {
	"hat0uma/csvview.nvim",
	ft = "csv",
	config = Config("csvview", function(plugin)
		plugin.setup({
			view = {
				display_mode = "border",
			},
		})

		local group = CreateAugroup("zsb_csvview")

		Cautocmd("FileType", {
			pattern = "csv",
			callback = function()
				plugin.enable()
			end,
			group = group,
		})
	end),
}
