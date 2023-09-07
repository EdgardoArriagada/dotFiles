kset("v", "ii", function()
	VisualInIndent()
end, { noremap = true, silent = true })

function VisualInIndent()
	-- Go to beggin of line and add to jump list
	Execute("normal<Esc>^m'")

	local lineMarker = getFirstNoEmptyLine("k", line("."))
	local lastSameIndentUp = getLesserIndent("k", lineMarker) + 1

	Execute("normal" .. lastSameIndentUp .. "GV")

	local lastSameIndentDown = getLesserIndent("j", lineMarker) - 1

	Execute("normal" .. lastSameIndentDown .. "G^")
end
