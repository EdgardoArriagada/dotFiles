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
	ShowMenu({
		title = "Paste to Quickfix",
		callback = function()
			local buf_id = vim.api.nvim_get_current_buf()
			local file_list = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)

			print(vim.inspect(file_list)) -- You can replace this with any logic to handle the modified list

			local qf_entries = {}
			for _, file in ipairs(file_list) do
				table.insert(qf_entries, { filename = file, lnum = 1, col = 1 })
			end

			vim.fn.setqflist(qf_entries)
		end,
	})
end

function ShowMenu(conf, opts)
	local height = conf.height or 20
	local width = conf.width or 60
	local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

	local Win_id = require("plenary.popup").create(opts or {}, {
		title = conf.title,
		line = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = height,
		borderchars = borderchars,
		callback = conf.callback,
	})

	function CloseMenu()
		vim.api.nvim_win_close(Win_id, true)
	end

	local bufnr = vim.api.nvim_win_get_buf(Win_id)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua CloseMenu()<CR>", { silent = false })
end
