function PasteToQf()
	ShowMenu({
		title = "Paste to Quickfix",
		callback = function()
			local buf_id = vim.api.nvim_get_current_buf()
			local file_list = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)

			local qf_entries = {}
			for _, file in ipairs(file_list) do
				if file ~= "" then
					table.insert(qf_entries, { filename = file, lnum = 1, col = 1 })
				end
			end

			vim.fn.setqflist(qf_entries)
			vim.cmd("copen")
		end,
	})
end
