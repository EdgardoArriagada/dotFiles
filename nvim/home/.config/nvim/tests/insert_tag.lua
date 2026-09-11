local utils = require("zsb.customPluggins.whichKeyUtils")

vim.ui.input = function(_, callback)
	callback(" --my ??? tag-- ")
end

local buffer = vim.api.nvim_create_buf(false, true)
vim.api.nvim_set_current_buf(buffer)
vim.api.nvim_buf_set_lines(buffer, 0, -1, false, { "" })
vim.fn.setreg('"', "hello", "v")
utils.insert_tag()
assert(vim.deep_equal(vim.api.nvim_buf_get_lines(buffer, 0, -1, false), {
	"<my-tag>",
	"hello",
	"</my-tag>",
}))

vim.api.nvim_buf_set_lines(buffer, 0, -1, false, { "hello" })
vim.api.nvim_win_set_cursor(0, { 1, 0 })
vim.cmd("normal! v$")
utils.insert_tag_visual()
assert(vim.deep_equal(vim.api.nvim_buf_get_lines(buffer, 0, -1, false), {
	"<my-tag>",
	"hello",
	"</my-tag>",
}))

print("insert tag: ok")
