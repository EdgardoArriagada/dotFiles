-- if vim.v.foldlevel = 2 then spaces = 2
-- if vim.v.foldlevel = 3 then spaces = 4
-- if vim.v.foldlevel = 4 then spaces = 6
-- if vim.v.foldlevel = 5 then spaces = 8
-- ...
local calculateSpaces = function(foldLevel)
	if foldLevel <= 2 then
		return foldLevel
	end
	local spaces = 2
	for i = 3, foldLevel do
		spaces = spaces + 2
	end
	return spaces
end

whenOk(require, "pretty-fold", function(prettyFold)
	prettyFold.setup({
		keep_indentation = false,
		fill_char = "━",
		sections = {
			left = {
				"⮀",
				function()
					return string.rep("·", calculateSpaces(vim.v.foldlevel) - 2)
				end,
				"content",
				"┣",
			},
			right = {
				"┫ ",
				"number_of_folded_lines",
				": ",
				"percentage",
				" ┣━━",
			},
		},
	})
end)
