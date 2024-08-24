function Exec(str)
	vim.api.nvim_exec(str, false)
end

-- Use this when Exec has characters like <CR> or <C-...>
function SafeExec(str)
	vim.api.nvim_exec(vim.api.nvim_replace_termcodes(str, true, true, true), false)
end
