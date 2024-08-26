local NEXT = 1
local PREV = -1

local function cycleQflist(direction)
	local qflen = #vim.fn.getqflist()

	local nextIdx = vim.fn.line(".") + direction

	if nextIdx < 1 then
		return Exec("clast")
	end

	if nextIdx > qflen then
		return Exec("cfirst")
	end

	Exec("cc " .. nextIdx)
end

local function cycleAndFocusBack(direction)
	return function()
		cycleQflist(direction)
		Exec("copen")
	end
end

local function qfClose()
	Exec("cclose")
end

local function qfEnter()
	Exec("cc")
	Exec("cclose")
end

local opts = { buffer = true }

kset("n", "<tab>", cycleAndFocusBack(NEXT), opts)
kset("n", "<s-tab>", cycleAndFocusBack(PREV), opts)

kset("n", "<Cr>", qfEnter, opts)
kset("n", "<C-c>", qfClose, opts)
