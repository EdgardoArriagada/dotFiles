return {
	"EdgardoArriagada/vaquero-shoot.nvim",
	config = Config("vaquero-shoot", function(vqs)
		-- enclosing
		kset("n", "W", function()
			vqs.beginEnclosingSelection()
		end)

		kset("v", "W", function()
			vqs.cycleEnclosingSelection()
		end)

		-- quotes
		kset({ "o", "v" }, "'", function()
			vqs.quotesSelection()
		end)
	end),
}
