return {
	"hat0uma/csvview.nvim",
	ft = "csv",
	config = Config("csvview", function(plugin)
		plugin.setup({
			view = {
				display_mode = "border",
			},
		})
		plugin.enable()
	end),
}
