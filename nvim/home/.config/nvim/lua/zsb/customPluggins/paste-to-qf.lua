-- Function to add files from clipboard to the quickfix
--
-- example of pasted files
-- src/__tests__/
-- src/__tests__/utils/zsb-utils/doesMatch.test.zsh
-- src/spells/node/dailycode/template/code.test.js
-- src/utils/zsb-utils/testing/
-- src/utils/zsb-utils/testing/testing.zsh
--
function PasteToQf()
	-- Prompt user for input
	local file_list = {}

	ShowMenu({}, function()
		-- Get the clipboard contents
		local input = vim.fn.getreg("+")

		-- Split the input string by newlines and trim whitespace
		for file in string.gmatch(input, "[^%s]+") do
			table.insert(file_list, file)
		end
	end)

	local qf_entries = {}

	for _, file in ipairs(file_list) do
		table.insert(qf_entries, { filename = file })
	end

	vim.fn.setqflist(qf_entries)
end

function ShowMenu(opts, cb)
	local height = 20
	local width = 30
	local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

	local Win_id = require("plenary.popup").create(opts, {
		title = "MyProjects",
		highlight = "MyProjectWindow",
		line = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = height,
		borderchars = borderchars,
		callback = cb,
	})

	function CloseMenu()
		vim.api.nvim_win_close(Win_id, true)
	end

	local bufnr = vim.api.nvim_win_get_buf(Win_id)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua CloseMenu()<CR>", { silent = false })
end
