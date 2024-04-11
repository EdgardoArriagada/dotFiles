return {
	"EdgardoArriagada/search-replace.nvim",
	--[[ dir = "~/projects/per/search-replace.nvim", ]]
	keys = { "<C-r>", { "<C-r>", mode = "v" } },
	config = Config("search-replace", function(sr)
		kset("v", "<C-r>", function()
			sr.searchAndReplace()
		end)
	end),
}
