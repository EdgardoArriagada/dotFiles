return {
	"EdgardoArriagada/vaquero-shoot.nvim",
	config = function()
		Hpcall(require, "vaquero-shoot", {
			onOk = function(vqs)
				-- enclosing
				keymap.set("n", "W", function()
					vqs.beginEnclosingSelection()
				end)

				keymap.set("v", "W", function()
					vqs.cycleEnclosingSelection()
				end)

				-- quotes
				keymap.set({ "o", "v" }, "'", function()
					if vqs.hasQuotesSelection() then
						vqs.cycleQuotesSelection()
					else
						vqs.beginQuotesSelection()
					end
				end)
			end,
			onErr = "Failed to load vaquero-shoot.nvim",
		})
	end,
}
