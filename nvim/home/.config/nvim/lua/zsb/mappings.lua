--Remap space as leader key
Kset("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Shorcuts
Kset("o", "w", "iw")
Kset("o", "W", "iW")

-- kset("v", "W", "iw") -- disabled because it is used in a plugin
Kset("v", "w", "iw")
Kset("v", "R", "loh")

Kset("n", "F", "v$<left><left>")
Kset("n", "+", "A <esc>p")
-- delete some text 'A', then select some text 'B' and press +
-- 'A' has to be before 'B' when swapping inline
Kset("v", "+", '<Esc>`.``gv"xygvP``"xP')
--Duplicate selection
Kset("v", "Z", '"xy\'>"xpO<esc>')

-- You can trigger 'vap' 'vay' 'vad'
Kset("v", "aa", "$<left>")
Kset("v", "ay", "$<left>y")
Kset("v", "ad", "$<left>d")
Kset("v", "as", "$<left>s")
Kset("v", "ac", "$<left>c")
-- (special case: avoid yanking)
Kset("v", "ap", "'$hpgv\"'.v:register.'y`>'", { expr = true })

-- Paste many times over selected text without yanking it
Kset("x", "p", "'pgv\"'.v:register.'y`>'", { expr = true })
Kset("x", "P", "'Pgv\"'.v:register.'y`>'", { expr = true })

-- Go and trim visual selection
Kset("v", "gt", ":s/\\s\\+/ /g<CR> <BAR> :nohlsearch<CR>", { silent = true })

Kset("n", "<C-w>m", "<C-w>100>")

Kset("n", "n", "nzzzv")
Kset("n", "N", "Nzzzv")
Kset("n", "J", "mzJ`z")

-- Undo checkpoints
Kset("i", ",", ",<c-g>u")
Kset("i", ".", ".<c-g>u")
Kset("i", "!", "!<c-g>u")
Kset("i", "[", "[<c-g>u")
Kset("i", "]", "]<c-g>u")
Kset("i", "{", "{<c-g>u")
Kset("i", "}", "}<c-g>u")
Kset("i", '"', '"<c-g>u')
Kset("i", "'", "'<c-g>u")
Kset("i", "<", "<<c-g>u")
Kset("i", ">", "><c-g>u")
Kset("i", "<Space>", "<Space><c-g>u")

-- set command line in tcsh-style
Kset("c", "<C-a>", "<Home>")
Kset("c", "<C-e>", "<End>")
Kset("c", "<C-b>", "<Left>")
Kset("c", "<C-f>", "<Right>")
Kset("c", "<C-d>", "<Del>")
Kset("c", "<C-h>", "<BS>")
Kset("c", "<C-k>", "<C-u>")
Kset("c", "<C-w>", "<C-u>")
Kset("c", "<C-y>", "<C-r>+")
Kset("c", "<C-p>", "<Up>")
Kset("c", "<C-n>", "<Down>")
Kset("c", "<C-t>", "<C-r><C-w>")
Kset("c", "<C-j>", "<CR>")
Kset("c", "<C-m>", "<CR>")
-- it is pressing <enter> instead of <esc> for some reason
--[[ kset("c", "<C-c>", "<Esc>") ]]
Kset("c", "<C-v>", "<C-r>+")

-- Quit
Kset("n", "<C-q>", ":q!")
Kset("c", "<C-q>", "<C-u>qa!<cr>", { silent = true })

-- Save
Kset("n", "<C-s>", ":update<CR>", { silent = true })
Kset("v", "<C-s>", "<esc>:update<CR>", { silent = true })
Kset("i", "<C-s>", "<esc>:update<CR>", { silent = true })

-- Move highlighted text down 'Shift j'
Kset("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
-- Move highlighted text up 'Shift k'
Kset("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

-- Add moves of more than 5 to the jump list
Kset("n", "k", [[(v:count > 5 ? "m'" . v:count : "") . 'k']], { expr = true, desc = "if k > 5 then add to jumplist" })
Kset("n", "j", [[(v:count > 5 ? "m'" . v:count : "") . 'j']], { expr = true, desc = "if j > 5 then add to jumplist" })

CreateCmd("V", function()
	vim.wo.relativenumber = not vim.wo.relativenumber
end, {})

CreateCmd("W", function()
	Exec("w!")
	Exec("e!")
end, {})

CreateCmd("Json", function()
	vim.bo.filetype = "json"
	vim.opt.foldmethod = "syntax"
	vim.notify('Folds set to "syntax"')
end, {})

CreateCmd("Pjson", function()
	Hpcall(Exec, "%!jq .", { onErr = 'failed to execute ":%!jq .", make sure you have "jq" is installed' })
end, {})

-- Reload local plugin
CreateCmd("Reload", function(opts)
	local plugin = opts.args

	if not plugin then
		vim.notify("No plugin specified", "error")
		return
	end

	vim.notify("Reloading " .. plugin)

	if package.loaded[plugin] then
		package.loaded[plugin] = nil
	end

	P(require(plugin))
end, { nargs = 1 })
