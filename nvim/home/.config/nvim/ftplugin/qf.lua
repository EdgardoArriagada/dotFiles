local NEXT = 1
local PREV = -1

local function cycleQflist(direction)
	local qflen = #vim.fn.getqflist()
	local currIndex = vim.fn.line(".")

	local nextIdx = direction == NEXT and currIndex + 1 or currIndex - 1

	if nextIdx < 1 then
		nextIdx = qflen
	elseif nextIdx > qflen then
		nextIdx = 1
	end

	vim.cmd("cc " .. nextIdx)
end

local function cycleAndFocusBack(direction)
	return function()
		cycleQflist(direction)
		vim.cmd("copen")
	end
end

local opts = { buffer = true }

keymap.set("n", "<tab>", cycleAndFocusBack(NEXT), opts)
keymap.set("n", "j", cycleAndFocusBack(NEXT), opts)

keymap.set("n", "<s-tab>", cycleAndFocusBack(PREV), opts)
keymap.set("n", "k", cycleAndFocusBack(PREV), opts)

keymap.set("n", "<cr>", function()
	vim.cmd("cc")
	vim.cmd("cclose")
end, opts)
