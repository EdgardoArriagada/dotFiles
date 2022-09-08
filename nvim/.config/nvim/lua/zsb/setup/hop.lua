-- you can configure Hop the way you like here; see :h hop-config
hpcall(require, "hop", {
	onOk = function(hop)
		hop.setup({ keys = "etovxqpdygfblzhckisuran" })
	end,
	onErr = "failed to setup hop",
})

keymap.set("n", "s", function()
	require("hop").hint_char2()
end, { noremap = false, silent = true })
