local url_pattern = "(https?://[%w-_%.%?%.:/%+=&#]+)"

local function find_first_url_in_line(line)
	return string.match(line, url_pattern)
end

Kset("n", "gx", function()
	local url = find_first_url_in_line(vim.api.nvim_get_current_line())

	if url == nil then
		vim.notify("No URLs found in the current line.", ERROR)
		return
	end

	vim.ui.open(url)
end)

Kset("v", "gx", function()
	local url = find_first_url_in_line(GetVisualSelection())

	if url == nil then
		vim.notify("No URLs found in selection.", ERROR)
		return
	end

	SafeExec("norm!o<Esc>")

	vim.ui.open(url)
end)
