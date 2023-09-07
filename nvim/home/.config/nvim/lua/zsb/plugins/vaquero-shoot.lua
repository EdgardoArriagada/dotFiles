return {
	"EdgardoArriagada/vaquero-shoot.nvim",
	config = function()
		Hpcall(require, "vaquero-shoot", {
			onOk = function(vqs)
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
			end,
			onErr = "Failed to load vaquero-shoot.nvim",
		})
	end,
}
