function Exec(str)
	vim.api.nvim_exec2(str, {})
end

-- Use this when Exec has characters like <CR> or <C-...>
function SafeExec(str)
	vim.api.nvim_exec2(vim.api.nvim_replace_termcodes(str, true, true, true), {})
end
