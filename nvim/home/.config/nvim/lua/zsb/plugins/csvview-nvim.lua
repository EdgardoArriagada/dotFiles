return {
	"hat0uma/csvview.nvim",
	ft = "csv",
	config = Config("csvview", function(plugin)
		plugin.setup()
		plugin.enable()
	end),
}
