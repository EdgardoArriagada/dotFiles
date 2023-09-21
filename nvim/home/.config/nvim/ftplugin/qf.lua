local NEXT = 1
local PREV = -1

local function cycleQflist(direction)
	local qflen = #vim.fn.getqflist()

	local nextIdx = vim.fn.line(".") + direction

	if nextIdx < 1 then
		return vim.cmd("clast")
	end

	if nextIdx > qflen then
		return vim.cmd("cfirst")
	end

	vim.cmd("cc " .. nextIdx)
end

local function cycleAndFocusBack(direction)
	return function()
		cycleQflist(direction)
		vim.cmd("copen")
	end
end

local function qfClose()
	vim.cmd("cclose")
end

local function qfEnter()
	vim.cmd("cc")
	vim.cmd("cclose")
end

local opts = { buffer = true }

kset("n", "<tab>", cycleAndFocusBack(NEXT), opts)
kset("n", "<s-tab>", cycleAndFocusBack(PREV), opts)

kset("n", "<Cr>", qfEnter, opts)
kset("n", "<C-c>", qfClose, opts)
