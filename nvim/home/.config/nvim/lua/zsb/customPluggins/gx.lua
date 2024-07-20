local url_pattern = "(https?://[%w-_%.%?%.:/%+=&#]+)"

local function find_first_url_in_line(line)
	return string.match(line, url_pattern)
end

kset("n", "gx", function()
	local url = find_first_url_in_line(vim.api.nvim_get_current_line())

	if url == nil then
		vim.notify("No URLs found in the current line.")
		return
	end

	vim.ui.open(url)
end)

kset("v", "gx", function()
	local url = find_first_url_in_line(GetVisualSelection())

	Execute("norm!o<Esc>")

	if url == nil then
		vim.notify("No URLs found in selection.")
		return
	end

	vim.ui.open(url)
end)
