kset("v", "q", function()
	Execute("normal<Esc>")
	VaqueroSelect()
end, { noremap = true, silent = true })

kset("o", "q", function()
	VaqueroSelect()
end, { noremap = true, silent = true })

function VaqueroSelect()
	GoLessDeeperIndent("k")
	Execute("normal!V")
	lookForIndentation("j")
end
