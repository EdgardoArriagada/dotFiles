if vim.g.vscode then
	return
end

hpcall(require, "indent_blankline", {
	onOk = function(indent_blankline)
		indent_blankline.setup({
			space_char_blankline = " ",
			show_current_context = true,
			show_current_context_start = true,
		})
	end,
	onErr = "failed to setup indent-blankline",
})
