Kset({ "o", "n", "v" }, "<bs>", function()
	GoLessDeeperIndent("k")
end, { silent = true })

Kset({ "o", "n", "v" }, "<enter>", function()
	-- I use enter to unfold lines as well
	if IsCurrentLineFolded() then
		Exec("normal! zO")
	else
		GoLessDeeperIndent("j")
	end
end, { silent = true })

function GoLessDeeperIndent(direction)
	-- Go to beggin of line and add to jump list
	Exec("normal^m'")

	local lesserIndent = GetSafeLesserIndent(direction)

	Exec("normal" .. lesserIndent .. "G^")
end
