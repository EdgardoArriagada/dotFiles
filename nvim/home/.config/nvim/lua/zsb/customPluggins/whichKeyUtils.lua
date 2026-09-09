local M = {}

function M.jump(a)
	return function()
		vim.diagnostic.jump({ count = a.direction, float = true, severity = a.severity })
	end
end

local function paste_prompt(prompt)
	return function()
		vim.api.nvim_put(vim.split(prompt.get(), "\n"), "l", true, true)
	end
end

function M.prompt_with_desc(key, prompt)
	return { key, paste_prompt(prompt), desc = prompt.desc }
end

function M.paste_link()
	local link = vim.fn.getreg("+"):gsub("%s+$", "")
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))

	vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { "[](" .. link .. ")" })
	vim.api.nvim_win_set_cursor(0, { row, col + 1 })
	vim.cmd("startinsert")
end

function M.paste_link_visual()
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
