return {
	"EdgardoArriagada/vaquero-shoot.nvim",
	--[[ dir = "~/projects/per/vaquero-shoot.nvim", ]]
	keys = { "W", "E", { "W", mode = "v" }, { "E", mode = "v" }, { "'", mode = "v" }, { '"', mode = "v" } },
	config = Config("vaquero-shoot", function(vqs)
		-- enclosing
		kset("n", "E", vqs.beginEnclosingSelection)
		kset("v", "E", vqs.cycleEnclosingSelection)
		kset("n", "W", vqs.beginEnclosingSelectionBackwards)
		kset("v", "W", vqs.cycleEnclosingSelectionBackwards)

		-- quotes
		kset({ "o", "v" }, "'", vqs.quotesSelection)
		kset({ "o", "v" }, '"', vqs.quotesSelectionBackwards)
	end),
}
