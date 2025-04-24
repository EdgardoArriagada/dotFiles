-- Alias to vim.cmd
-- When using characters like <CR> or <C-...> use SafeExec instead
function Exec(str)
	vim.api.nvim_exec2(str, {})
end

-- Alias to vim.cmd
-- If not using characters like <CR> or <C-...> use Exec instead
function SafeExec(str)
	vim.api.nvim_exec2(vim.api.nvim_replace_termcodes(str, true, true, true), {})
end
