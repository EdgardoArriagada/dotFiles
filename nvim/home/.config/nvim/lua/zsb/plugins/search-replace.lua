return {
	"EdgardoArriagada/search-replace.nvim",
	--[[ dir = "~/projects/per/search-replace.nvim", ]]
	keys = { "#", { "#", mode = "v" } },
	config = Config("search-replace", function(sr)
		kset("v", "#", function()
			sr.searchAndReplace()
		end)

		kset("n", "#", function()
			Execute("normal!<Esc>viw")

			sr.searchAndReplace()
		end)
	end),
}
