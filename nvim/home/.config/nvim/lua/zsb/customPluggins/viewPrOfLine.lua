function ViewPrOfLine()
	local current_line = vim.fn.line(".")
	local current_file = vim.fn.expand("%")

	local git_cmd = "git blame -sl -L "
		.. current_line
		.. ","
		.. current_line
		.. " "
		.. current_file
		.. " | cut -d ' ' -f1"

	local commit_hash = fromShell(git_cmd)

	if not commit_hash or commit_hash:sub(1, 1) == "^" then
		print("No commit found for this line")
		return
	end

	local repoUrl = fromShell("get_repo_url")

	fromShell("zsb_open " .. repoUrl .. "/pulls?q=is%3Apr+" .. commit_hash)
end
