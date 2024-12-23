local function getCurrentLineCommitHash()
	local line_num = vim.api.nvim_win_get_cursor(0)[1]
	local file_name = vim.fn.expand("%")

	local commit_hash =
		vim.fn.system("git blame -sl -L " .. line_num .. "," .. line_num .. " " .. file_name .. " | cut -d ' ' -f1")

	if not commit_hash or commit_hash:sub(1, 1) == "^" then
		return false, nil
	end

	return true, commit_hash
end

function ViewPrOfLine()
	local ok, commit_hash = getCurrentLineCommitHash()

	if not ok then
		vim.notify("No commit found for this line", ERROR)
		return
	end

	local repoUrl = vim.fn.system("get_repo_url")

	vim.ui.open(repoUrl .. "/pulls?q=is%3Apr+" .. commit_hash)
end
