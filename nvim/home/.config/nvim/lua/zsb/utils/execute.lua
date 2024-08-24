function Execute(str)
	vim.api.nvim_exec(vim.api.nvim_replace_termcodes(str, true, true, true), false)
end
