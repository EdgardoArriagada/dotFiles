keymap.set({ "o", "n", "v" }, "<bs>", function()
	GoLessDeeperIndent("k")
end, { silent = true })

keymap.set({ "o", "n", "v" }, "<enter>", function()
	GoLessDeeperIndent("j")
end, { silent = true })

function GoLessDeeperIndent(direction)
	-- Go to beggin of line and add to jump list
	Execute("normal^m'")

	local lineMarker = getFirstNoEmptyLine(direction, line("."))

	local originalInent = indent(lineMarker)

	if originalInent == 0 then
		local lastLine = getSameIndentLine(direction, lineMarker)
		Execute("normal" .. lastLine .. "G^")
		return
	end

	local lastMatchinLine = getLesserIndent(direction, lineMarker)

	Execute("normal" .. lastMatchinLine .. "G^")
end
