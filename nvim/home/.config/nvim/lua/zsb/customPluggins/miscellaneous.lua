function OpenBufferInNewTmuxWindow(opts)
	vim.system({ "tmux", "new-window", "nvim", vim.fn.expand("%:p") })
	if opts ~= "NoClose" then
		Exec("q!")
	end
end

function FullGitSplit()
	Exec("Gvdiffsplit!")
	OpenBufferInNewTmuxWindow()
end

function Cppath()
	local repoRoot = EscapePattern(vim.system({ "git", "rev-parse", "--show-toplevel" }):wait().stdout:gsub("\n", ""))
	local path = vim.fn.expand("%:p")

	local result = path:gsub(repoRoot .. "/", "")

	vim.fn.setreg("+", result)
	vim.notify(result .. " Copied!")
end

function CppathHome()
	local home = EscapePattern(vim.env.HOME)
	local path = vim.fn.expand("%:p")

	local result = path:gsub("^" .. home, "~")

	vim.fn.setreg("+", result)
	vim.notify(result .. " Copied!")
end

function ToggleSetWrap()
	vim.wo.wrap = not vim.wo.wrap
end

function ToggleRelativeNumber()
	vim.wo.relativenumber = not vim.wo.relativenumber
end

function ToggleBool()
	local map = {
		["true"] = "false", ["false"] = "true",
		["True"] = "False", ["False"] = "True",
		["TRUE"] = "FALSE", ["FALSE"] = "TRUE",
	}

	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	local cursor_lua = col + 1

	local function is_word(ln, s, e)
		return (s == 1 or not ln:sub(s - 1, s - 1):match("%w"))
			and (e == #ln or not ln:sub(e + 1, e + 1):match("%w"))
	end

	local function apply(r, s, w)
		vim.api.nvim_buf_set_text(0, r - 1, s - 1, r - 1, s - 1 + #w, { map[w] })
	end

	-- cursor on a boolean: toggle in place
	for w in pairs(map) do
		local s = 1
		while true do
			s = line:find(w, s, true)
			if not s then break end
			local e = s + #w - 1
			if is_word(line, s, e) and s <= cursor_lua and cursor_lua <= e then
				apply(row, s, w)
				return
			end
			s = e + 1
		end
	end

	-- scan forward line by line
	for r = row, vim.api.nvim_buf_line_count(0) do
		local ln = vim.api.nvim_buf_get_lines(0, r - 1, r, false)[1]
		local from = r == row and cursor_lua + 1 or 1
		local best_s, best_w = nil, nil
		for w in pairs(map) do
			local s = ln:find(w, from, true)
			if s and is_word(ln, s, s + #w - 1) and (not best_s or s < best_s) then
				best_s, best_w = s, w
			end
		end
		if best_s then apply(r, best_s, best_w) return end
	end

	-- nothing forward: scan backward line by line
	for r = row, 1, -1 do
		local ln = vim.api.nvim_buf_get_lines(0, r - 1, r, false)[1]
		local upto = r == row and cursor_lua - 1 or #ln
		local best_s, best_w = nil, nil
		for w in pairs(map) do
			local s = 1
			while true do
				s = ln:find(w, s, true)
				if not s then break end
				local e = s + #w - 1
				if e <= upto and is_word(ln, s, e) and (not best_s or s > best_s) then
					best_s, best_w = s, w
				end
				s = e + 1
			end
		end
		if best_s then apply(r, best_s, best_w) return end
	end
end

-- returns the content of the given line number
--- @param lnum number: The line number
function GetLineContent(lnum)
	return vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, true)[1]
end

function GetCurrentLNum()
	return vim.api.nvim_win_get_cursor(0)[1]
end

function GetCurrentCol()
	return vim.api.nvim_win_get_cursor(0)[2] + 1
end
