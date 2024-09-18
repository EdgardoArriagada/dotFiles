local triggerChars = { "W", "E", "'", '"' }

local keys = {}

for _, char in ipairs(triggerChars) do
	table.insert(keys, char)
	table.insert(keys, { char, mode = "v" })
	table.insert(keys, { char, mode = "o" })
end

return {
	"EdgardoArriagada/vaquero-shoot.nvim",
	--[[ dir = "~/projects/per/vaquero-shoot.nvim", ]]
	keys = keys,
	config = Config("vaquero-shoot", function(vqs)
		-- enclosing
		Kset("n", "E", vqs.beginEnclosingSelection)
		Kset("v", "E", vqs.cycleEnclosingSelection)
		Kset("o", "E", vqs.enclosingSelection)

		Kset("n", "W", vqs.beginEnclosingSelectionBackwards)
		Kset("v", "W", vqs.cycleEnclosingSelectionBackwards)
		Kset("o", "W", vqs.enclosingSelectionBackwards)

		-- quotes
		Kset({ "v", "o" }, "'", vqs.quotesSelection)

		Kset({ "v", "o" }, '"', vqs.quotesSelectionBackwards)
	end),
}
