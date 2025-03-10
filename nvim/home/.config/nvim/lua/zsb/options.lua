local options = {
	clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	fileencoding = "utf-8", -- the encoding written to a file
	ignorecase = true, -- ignore case in search patterns
	mouse = "",
	timeoutlen = 600, -- time to wait for a mapped sequence to complete (in milliseconds)
	autoread = true, -- automatically reload a file if it changes from the outside
	backup = false, -- creates a backup file
	colorcolumn = "80,120", -- highlight given columns
	cmdheight = 2, -- more space in the neovim command line for displaying messages
	completeopt = { "menuone", "noselect" }, -- mostly just for cmp
	conceallevel = 0, -- so that `` is visible in markdown files
	hlsearch = true, -- highlight all matches on previous search pattern
	pumheight = 10, -- pop up menu height
	showmode = false, -- we don't need to see things like -- INSERT -- anymore
	showtabline = 2, -- always show tabs
	smartcase = true, -- smart case
	smartindent = true, -- make indenting smarter again
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	swapfile = false, -- creates a swapfile
	termguicolors = true, -- set term gui colors (most terminals support this)
	updatetime = 300, -- faster completion (4000ms default)
	writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	expandtab = true, -- convert tabs to spaces
	shiftwidth = 2, -- the number of spaces inserted for each indentation
	tabstop = 2, -- insert 2 spaces for a tab
	cursorline = true, -- highlight the current line
	number = true, -- set numbered lines
	relativenumber = true, -- set relative numbered lines
	numberwidth = 4, -- set number column width to 2 {default 4}
	signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
	wrap = false, -- display lines as one long line
	scrolloff = 8, -- is one of my fav
	sidescrolloff = 8,
	guifont = "Hack Nerd Font:h21", -- the font used in graphical neovim applications
	laststatus = 3, -- global statusline only
}

local appendOptions = {
	shortmess = "c", -- don't pass messages to |ins-completion-menu|.
	whichwrap = "<>[]hl", -- move to next line with theses keys
	iskeyword = "-", -- treat dash separated words as a word text object"
}

-------------------------------------------------------------------------------

local opt = vim.opt

for k, v in pairs(options) do
	opt[k] = v
end

for k, v in pairs(appendOptions) do
	opt[k]:append(v)
end
