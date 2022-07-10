if vim.g.vscode then
	return
end

whenOk(require, "indent_blankline", function(indent_blankline)
	indent_blankline.setup({
		space_char_blankline = " ",
		show_current_context = true,
		show_current_context_start = true,
	})
end)
