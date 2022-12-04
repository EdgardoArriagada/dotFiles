hpcall(require, "nvim-treesitter.configs", {
	onOk = function(config)
		local yellow = "#d8a657"
		local blue = "#7daea3"
		--[[ local aqua = "#89b482" ]]
		local purple = "#d3869b"
		local orange = "#e78a4e"
		local green = "#a9b665"
		config.setup({
			rainbow = {
				colors = {
					purple,
					yellow,
					orange,
					green,
					blue,
				},
			},
		})
	end,
	onErr = "failed to setup rainbow conf",
})
