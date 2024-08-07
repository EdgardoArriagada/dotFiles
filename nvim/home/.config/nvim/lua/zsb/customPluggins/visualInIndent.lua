function VisualInIndent()
	-- Go to beggin of line and add to jump list
	Execute("normal<Esc>^m'")

	local lineMarker = GetFirstNoEmptyLine("k", line("."))
	local lastSameIndentUp = getLesserIndent("k", lineMarker) + 1

	Execute("normal" .. lastSameIndentUp .. "GV")

	local lastSameIndentDown = getLesserIndent("j", lineMarker) - 1

	Execute("normal" .. lastSameIndentDown .. "G^")
end

kset("v", "ii", VisualInIndent, { noremap = true, silent = true })
