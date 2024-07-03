--Remap space as leader key
kset("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Shorcuts
kset("o", "w", "iw")
kset("o", "W", "iW")

-- kset("v", "W", "iw") -- disabled because it is used in a plugin
kset("v", "w", "iw")
kset("v", "R", "loh")

kset("n", "F", "v$<left><left>")
kset("n", "+", "A <esc>p")
-- delete some text 'A', then select some text 'B' and press +
-- 'A' has to be before 'B' when swapping inline
kset("v", "+", '<Esc>`.``gv"xygvP``"xP')
--Duplicate selection
kset("v", "Z", '"xy\'>"xpO<esc>')

-- You can trigger 'vap' 'vay' 'vad'
kset("v", "aa", "$<left>")
kset("v", "ay", "$<left>y")
kset("v", "ad", "$<left>d")
kset("v", "as", "$<left>s")
kset("v", "ac", "$<left>c")
-- (special case: avoid yanking)
kset("v", "ap", "'$hpgv\"'.v:register.'y`>'", { expr = true })

-- Paste many times over selected text without yanking it
kset("x", "p", "'pgv\"'.v:register.'y`>'", { expr = true })
kset("x", "P", "'Pgv\"'.v:register.'y`>'", { expr = true })

-- Go and trim visual selection
kset("v", "gt", ":s/\\s\\+/ /g<CR> <BAR> :nohlsearch<CR>", { silent = true })

kset("n", "<C-w>m", "<C-w>100>")

kset("n", "n", "nzzzv")
kset("n", "N", "Nzzzv")
kset("n", "J", "mzJ`z")

-- Undo checkpoints
kset("i", ",", ",<c-g>u")
kset("i", ".", ".<c-g>u")
kset("i", "!", "!<c-g>u")
kset("i", "[", "[<c-g>u")
kset("i", "]", "]<c-g>u")
kset("i", "{", "{<c-g>u")
kset("i", "}", "}<c-g>u")
kset("i", '"', '"<c-g>u')
kset("i", "'", "'<c-g>u")
kset("i", "<", "<<c-g>u")
kset("i", ">", "><c-g>u")
kset("i", "<Space>", "<Space><c-g>u")

-- set command line in tcsh-style
kset("c", "<C-a>", "<Home>")
kset("c", "<C-e>", "<End>")
kset("c", "<C-b>", "<Left>")
kset("c", "<C-f>", "<Right>")
kset("c", "<C-d>", "<Del>")
kset("c", "<C-h>", "<BS>")
kset("c", "<C-k>", "<C-u>")
kset("c", "<C-w>", "<C-u>")
kset("c", "<C-y>", "<C-r>+")
kset("c", "<C-p>", "<Up>")
kset("c", "<C-n>", "<Down>")
kset("c", "<C-t>", "<C-r><C-w>")
kset("c", "<C-j>", "<CR>")
kset("c", "<C-m>", "<CR>")
-- it is pressing <enter> instead of <esc> for some reason
--[[ kset("c", "<C-c>", "<Esc>") ]]
kset("c", "<C-v>", "<C-r>+")

-- Quit
kset("n", "<C-q>", ":q!")
kset("c", "<C-q>", "<C-u>qa!<cr>")

-- Save
kset("n", "<C-s>", ":update<CR>", { silent = true })
kset("v", "<C-s>", "<esc>:update<CR>", { silent = true })
kset("i", "<C-s>", "<esc>:update<CR>", { silent = true })

-- Move highlighted text down 'Shift j'
kset("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
-- Move highlighted text up 'Shift k'
kset("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

-- Add moves of more than 5 to the jump list
kset("n", "k", [[(v:count > 5 ? "m'" . v:count : "") . 'k']], { expr = true, desc = "if k > 5 then add to jumplist" })
kset("n", "j", [[(v:count > 5 ? "m'" . v:count : "") . 'j']], { expr = true, desc = "if j > 5 then add to jumplist" })

createCmd("V", function()
	vim.wo.relativenumber = not vim.wo.relativenumber
end, {})

createCmd("W", function()
	vim.cmd("w!")
	vim.cmd("e!")
end, {})

createCmd("Json", function()
	vim.bo.filetype = "json"
	vim.opt.foldmethod = "syntax"
	print('Folds set to "syntax"')
end, {})

createCmd("Pjson", function()
	Hpcall(Execute, "%!jq .", { onErr = 'failed to execute ":%!jq .", make sure you have "jq" is installed' })
end, {})

-- Toggle quickfix window
createCmd("T", function()
	for _, win in pairs(vim.fn.getwininfo()) do
		if win.quickfix == 1 then
			return vim.cmd("cclose")
		end
	end
	vim.cmd("copen")
end, {})

-- Reload local plugin
createCmd("Reload", function(opts)
	local plugin = opts.args

	if not plugin then
		print("No plugin specified")
		return
	end

	print("Reloading " .. plugin)

	if package.loaded[plugin] then
		package.loaded[plugin] = nil
	end

	P(require(plugin))
end, { nargs = 1 })
