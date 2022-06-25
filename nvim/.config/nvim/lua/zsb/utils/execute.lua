function execute(str)
  vim.cmd(vim.api.nvim_replace_termcodes(str, true, true, true))
end
