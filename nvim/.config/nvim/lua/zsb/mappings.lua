--Remap space as leader key
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Shorcuts
keymap.set("o", "w", "iw")
keymap.set("o", "W", "iW")
--
-- keymap.set("v", "W", "iw") -- disabled because it is used in a plugin
keymap.set("v", "w", "iw")
keymap.set("v", "R", "loh")
--

keymap.set("n", "S", "v$<left><left>")
keymap.set("n", "+", "A <esc>p")
-- Swapping: delete some text, then visual select other text, execute the maped
-- key and the swap is made
keymap.set("v", "+", "<Esc>`.``gvP``P")
--Duplicate selection
keymap.set("v", "Z", '"xy\'>"xpO<esc>')

-- You can trigger 'vap' 'vay' 'vad'
keymap.set("v", "aa", "$<left>")
keymap.set("v", "ay", "$<left>y")
keymap.set("v", "ad", "$<left>d")
keymap.set("v", "as", "$<left>s")
keymap.set("v", "ac", "$<left>c")
-- (special case: avoid yanking)
keymap.set("v", "ap", "'$hpgv\"'.v:register.'y`>'", { expr = true })

-- Paste many times over selected text without yanking it
keymap.set("x", "p", "'pgv\"'.v:register.'y`>'", { expr = true })
keymap.set("x", "P", "'Pgv\"'.v:register.'y`>'", { expr = true })

-- Go and trim visual selection
keymap.set("v", "gt", ":s/\\s\\+/ /g<CR>")

keymap.set("n", "<C-w>m", "<C-w>100>")
keymap.set("n", "<C-h>", "<C-w>h")
keymap.set("n", "<C-j>", "<C-w>j")
keymap.set("n", "<C-k>", "<C-w>k")
keymap.set("n", "<C-l>", "<C-w>l")

keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")
keymap.set("n", "J", "mzJ`z")

-- Undo checkpoints
keymap.set("i", ",", ",<c-g>u")
keymap.set("i", ".", ".<c-g>u")
keymap.set("i", "!", "!<c-g>u")
keymap.set("i", "[", "[<c-g>u")
keymap.set("i", "]", "]<c-g>u")
keymap.set("i", "{", "{<c-g>u")
keymap.set("i", "}", "}<c-g>u")
keymap.set("i", '"', '"<c-g>u')
keymap.set("i", "'", "'<c-g>u")
keymap.set("i", "<", "<<c-g>u")
keymap.set("i", ">", "><c-g>u")
keymap.set("i", "<Space>", "<Space><c-g>u")

-- Quit
keymap.set("n", "<C-q>", ":q")
keymap.set("c", "<C-q>", "<C-u>q") -- redraw ':q'

-- Save
keymap.set("n", "<C-s>", ":update<CR>", { silent = true })
keymap.set("v", "<C-s>", "<esc>:update<CR>", { silent = true })
keymap.set("i", "<C-s>", "<esc>:update<CR>", { silent = true })

-- Move highlighted text down 'Shift j'
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- Move highlighted text up 'Shift k'
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Add moves of more than 5 to the jump list
keymap.set(
	"n",
	"k",
	[[(v:count > 5 ? "m'" . v:count : "") . 'k']],
	{ expr = true, desc = "if k > 5 then add to jumplist" }
)
keymap.set(
	"n",
	"j",
	[[(v:count > 5 ? "m'" . v:count : "") . 'j']],
	{ expr = true, desc = "if j > 5 then add to jumplist" }
)

vim.api.nvim_create_user_command("V", ":set nornu", {})

vim.api.nvim_create_user_command("Cppath", function()
	local repoName = escape_pattern(fromShell("get_repo_name"))
	local path = vim.fn.expand("%:p")

	local result = path:gsub("^.*" .. repoName .. "/", ""):gsub("^%./", "")

	vim.fn.setreg("+", result)
	print(result .. " Copied!")
end, {})

vim.api.nvim_create_user_command("Tjsfile", function()
	local fileName = vim.fn.expand("%:t")
	local extension = vim.fn.expand("%:e")
	if string.match(fileName, ".spec." .. extension) then
		execute("e " .. getProductionCodeFileJS())
	else
		execute("e " .. getTestFileJs())
	end
end, {})

vim.api.nvim_create_user_command("Json", function()
	vim.bo.filetype = "json"
	vim.opt.foldmethod = "syntax"
	print('Folds set to "syntax"')
end, {})

vim.api.nvim_create_user_command("Pjson", function()
	hpcall(execute, "%!jq .", { onErr = 'failed to execute ":%!jq .", make sure you have "jq" is installed' })
end, {})

-- Toggle quickfix window
vim.api.nvim_create_user_command("T", function()
	for _, win in pairs(vim.fn.getwininfo()) do
		if win.quickfix == 1 then
			vim.cmd("cclose")
			return
		end
	end
	vim.cmd("copen")
end, {})

--Search and replace matches for highlighted text
keymap.set("v", "<C-r>", function()
	--[[ '"hy:.,$s/<C-r>h//gc<left><left><left>') ]]
	local replaceString = vim.fn.input("Replace: ")
	local vSelection = getVisualSelectionInLine()
	execute("normal<Esc>")
	execute(".,$s/" .. escapeForRegex(vSelection) .. "/" .. escapeForRegex(replaceString) .. "/gc")
	execute("nohlsearch")
end)
