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

	local function is_word_boundary(s, e)
		return (s == 1 or not line:sub(s - 1, s - 1):match("%w"))
			and (e == #line or not line:sub(e + 1, e + 1):match("%w"))
	end

	-- build position map for all booleans on current line
	local positions = {}
	for w in pairs(map) do
		local s = 1
		while true do
			s = line:find(w, s, true)
			if not s then break end
			local e = s + #w - 1
			if is_word_boundary(s, e) then
				table.insert(positions, { s, e, w })
			end
			s = e + 1
		end
	end

	if #positions == 0 then return end

	local function apply(entry)
		vim.api.nvim_buf_set_text(0, row - 1, entry[1] - 1, row - 1, entry[2], { map[entry[3]] })
	end

	-- cursor on a boolean: toggle in place
	for _, entry in ipairs(positions) do
		if cursor_lua >= entry[1] and cursor_lua <= entry[2] then
			apply(entry)
			return
		end
	end

	local best_right, best_left = nil, nil
	for _, entry in ipairs(positions) do
		if entry[1] > cursor_lua and (not best_right or entry[1] < best_right[1]) then
			best_right = entry
		elseif entry[2] < cursor_lua and (not best_left or entry[1] > best_left[1]) then
			best_left = entry
		end
	end
	if best_right then apply(best_right) return end
	if best_left then apply(best_left) end
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
