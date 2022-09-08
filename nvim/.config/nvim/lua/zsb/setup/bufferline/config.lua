hpcall(require, "bufferline", {
	onOk = function(bufferline)
		bufferline.setup()
	end,
	onErr = "failed to setup bufferline",
})
