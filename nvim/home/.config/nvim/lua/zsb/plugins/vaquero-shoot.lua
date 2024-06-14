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
		kset("n", "E", vqs.beginEnclosingSelection)
		kset("v", "E", vqs.cycleEnclosingSelection)
		kset("o", "E", vqs.enclosingSelection)

		kset("n", "W", vqs.beginEnclosingSelectionBackwards)
		kset("v", "W", vqs.cycleEnclosingSelectionBackwards)
		kset("o", "W", vqs.enclosingSelectionBackwards)

		-- quotes
		kset("v", "'", vqs.cycleQuotesSelection)
		kset("o", "'", vqs.quotesSelection)

		kset("v", '"', vqs.cycleQuotesSelectionBackwards)
		kset("o", '"', vqs.quotesSelectionBackwards)
	end),
}
