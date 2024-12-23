local createCmd = vim.api.nvim_create_user_command

createCmd("W", function()
	Exec("w!")
	Exec("e!")
end, {})

createCmd("Json", function()
	vim.bo.filetype = "json"
	vim.opt.foldmethod = "syntax"
	vim.notify('Folds set to "syntax"')
end, {})

createCmd("Pjson", function()
	Hpcall(Exec, "%!jq .", { onErr = 'failed to execute ":%!jq .", make sure you have "jq" is installed' })
end, {})

-- Reload local plugin
createCmd("Reload", function(opts)
	local plugin = opts.args

	if not plugin then
		vim.notify("No plugin specified", ERROR)
		return
	end

	vim.notify("Reloading " .. plugin)

	if package.loaded[plugin] then
		package.loaded[plugin] = nil
	end

	P(require(plugin))
end, { nargs = 1 })
