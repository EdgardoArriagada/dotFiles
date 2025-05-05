function VaqueroSelect()
	-- Go to beggin of line and add to jump list
	Exec("normal^m'")

	local lessIndentUp = GetSafeLesserIndent("k")
	local lessIndentDown = GetSafeLesserIndent("j")

	Exec("normal" .. lessIndentUp .. "G^")
	Exec("normal!V")
	Exec("normal" .. lessIndentDown .. "G^")
end

Kset("v", "q", function()
	SafeExec("normal<Esc>")
	VaqueroSelect()
end, { noremap = true, silent = true })

Kset("o", "q", VaqueroSelect, { noremap = true, silent = true })
