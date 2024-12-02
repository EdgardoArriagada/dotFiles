return {
	"brenoprata10/nvim-highlight-colors",
	config = Config("nvim-highlight-colors", function(plugin)
		plugin.setup({
			render = "virtual",
			virtual_symbol_position = "eow",
			virtual_symbol_prefix = " ",
			virtual_symbol_suffix = "",
			enable_tailwind = true,
		})
	end),
}
