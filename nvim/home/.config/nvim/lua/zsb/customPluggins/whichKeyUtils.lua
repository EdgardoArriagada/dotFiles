local M = {}

function M.jump(a)
	return function()
		vim.diagnostic.jump({ count = a.direction, float = true, severity = a.severity })
	end
end

function M.prompt_with_desc(key, prompt)
	return {
		key,
		function() vim.api.nvim_put(vim.split(prompt.get(), "\n"), "l", true, true) end,
		desc = prompt.desc,
	}
end

function M.insert_link()
	local link = vim.fn.getreg("+"):gsub("%s+$", "")
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))

	vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { "[](" .. link .. ")" })
	vim.api.nvim_win_set_cursor(0, { row, col + 1 })
	vim.cmd("startinsert")
end

function M.insert_link_visual()
	local link = vim.fn.getreg("+"):gsub("%s+$", "")
	local mode = vim.fn.mode()
	local start_pos, end_pos = vim.fn.getpos("v"), vim.fn.getpos(".")
	local options = { type = mode, exclusive = vim.o.selection == "exclusive" }
	local text = vim.fn.getregion(start_pos, end_pos, options)
	options.eol = true
	local ranges = vim.fn.getregionpos(start_pos, end_pos, options)

	vim.cmd("normal! " .. vim.keycode("<Esc>"))

	if mode == "\22" then
		for i = #ranges, 1, -1 do
			local row = ranges[i][1][2] - 1
			local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]
			local start_col = math.min(ranges[i][1][3] - 1, #line)
			local end_col = math.min(start_col + #text[i], #line)

			vim.api.nvim_buf_set_text(0, row, start_col, row, end_col, { "[" .. text[i] .. "](" .. link .. ")" })
		end
		return
	end

	local start = ranges[1][1]
	local last = ranges[#ranges][1]
	local end_col = last[3] - 1 + #text[#text]
	text[1] = "[" .. text[1]
	text[#text] = text[#text] .. "](" .. link .. ")"
	vim.api.nvim_buf_set_text(0, start[2] - 1, start[3] - 1, last[2] - 1, end_col, text)
end

function M.insert_code_fence()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local text = vim.fn.getreg('"', 1, true)
	table.insert(text, 1, "```")
	table.insert(text, "```")
	vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, text)
	vim.api.nvim_win_set_cursor(0, { row, col + 2 })
	vim.cmd("startinsert!")
end

function M.insert_code_fence_visual()
	local mode = vim.fn.mode()
	local start_pos, end_pos = vim.fn.getpos("v"), vim.fn.getpos(".")
	local options = { type = mode, exclusive = vim.o.selection == "exclusive", eol = true }
	local text = vim.fn.getregion(start_pos, end_pos, options)
	local ranges = vim.fn.getregionpos(start_pos, end_pos, options)

	vim.cmd("normal! " .. vim.keycode("<Esc>"))
	local start = ranges[1][1]
	if mode == "\22" then
		for i = #ranges, 1, -1 do
			local start, last = ranges[i][1], ranges[i][2]
			vim.api.nvim_buf_set_text(0, start[2] - 1, start[3] - 1, last[2] - 1, last[3], {
				"```",
				text[i],
				"```",
			})
		end
	else
		local last = ranges[#ranges][1]
		local end_col = last[3] - 1 + #text[#text]
		table.insert(text, 1, "```")
		table.insert(text, "```")
		vim.api.nvim_buf_set_text(0, start[2] - 1, start[3] - 1, last[2] - 1, end_col, text)
	end

	vim.api.nvim_win_set_cursor(0, { start[2], start[3] + 1 })
	vim.cmd("startinsert!")
end

local function prompt_tag(callback)
	vim.ui.input({ prompt = "Tag name: " }, function(tag)
		if not tag then
			return
		end

		tag = tag:gsub("[^%w-]", "-"):gsub("-+", "-"):gsub("^%-", ""):gsub("%-$", "")
		if tag == "" then
			vim.notify("Tag name cannot be empty", vim.log.levels.WARN)
			return
		end

		callback("<" .. tag .. ">", "</" .. tag .. ">")
	end)
end

function M.insert_tag()
	prompt_tag(function(opening, closing)
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		local text = vim.fn.getreg('"', 1, true)
		table.insert(text, 1, opening)
		table.insert(text, closing)
		vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, text)
	end)
end

function M.insert_tag_visual()
	local mode = vim.fn.mode()
	local start_pos, end_pos = vim.fn.getpos("v"), vim.fn.getpos(".")
	local options = { type = mode, exclusive = vim.o.selection == "exclusive", eol = true }
	local text = vim.fn.getregion(start_pos, end_pos, options)
	local ranges = vim.fn.getregionpos(start_pos, end_pos, options)

	vim.cmd("normal! " .. vim.keycode("<Esc>"))
	prompt_tag(function(opening, closing)
		if mode == "\22" then
			for i = #ranges, 1, -1 do
				local start, last = ranges[i][1], ranges[i][2]
				vim.api.nvim_buf_set_text(0, start[2] - 1, start[3] - 1, last[2] - 1, last[3], {
					opening,
					text[i],
					closing,
				})
			end
			return
		end

		local start = ranges[1][1]
		local last = ranges[#ranges][1]
		local end_col = last[3] - 1 + #text[#text]
		table.insert(text, 1, opening)
		table.insert(text, closing)
		vim.api.nvim_buf_set_text(0, start[2] - 1, start[3] - 1, last[2] - 1, end_col, text)
	end)
end

function M.toggle_strikethrough()
	local STRIKE = "\xcc\xb6" -- U+0336 combining long stroke overlay

	local saved_a = { vim.fn.getreg("a"), vim.fn.getregtype("a") }

	vim.cmd('normal! "ay')
	local text = vim.fn.getreg("a")
	local reg_type = vim.fn.getregtype("a")

	local first = vim.fn.strcharpart(text, 0, 1)
	local is_struck = first ~= "" and text:sub(#first + 1, #first + 2) == STRIKE
	local new_text = is_struck and text:gsub(STRIKE, "") or vim.fn.substitute(text, "[^\\n]", "\\0" .. STRIKE, "g")

	vim.fn.setreg("a", new_text, reg_type)
	vim.cmd('normal! gv"ap')

	vim.fn.setreg("a", saved_a[1], saved_a[2])
end

return M
