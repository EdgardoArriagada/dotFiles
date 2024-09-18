Kset("v", "q", function()
	SafeExec("normal<Esc>")
	VaqueroSelect()
end, { noremap = true, silent = true })

Kset("o", "q", function()
	VaqueroSelect()
end, { noremap = true, silent = true })

function VaqueroSelect()
	GoLessDeeperIndent("k")
	Exec("normal!V")
	LookForIndentation("j")
end
