vim.filetype.add({
	pattern = {
		-- Detect bun files as typescript based on shebang
		[".*"] = {
			priority = -math.huge,
			function(_path, bufnr)
				local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
				if first_line and first_line:match("^#!/usr/bin/env%s+bun") then
					return "typescript"
				end
			end,
		},
	},
})
