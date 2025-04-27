local function visualInIndent()
	-- Go to beggin of line and add to jump list
	SafeExec("normal<Esc>^m'")

	local lineMarker = GetFirstNoEmptyLine("k", GetCurrentLNum())
	local lastSameIndentUp = GetLesserIndent("k", lineMarker) + 1

	Exec("normal" .. lastSameIndentUp .. "GV")

	local lastSameIndentDown = GetLesserIndent("j", lineMarker) - 1

	Exec("normal" .. lastSameIndentDown .. "G^")
end

Kset("v", "ii", visualInIndent, { noremap = true, silent = true })
