return {
'eddyekofo94/gruvbox-flat.nvim',
config= function()

-- Change here --
---------- -------- -------- --------
local theme = "gruvbox-flat"
vim.g.gruvbox_flat_style = "dark"
vim.g.gruvbox_theme = {
	Identifier = { fg = "blue" },
	Function = { fg = "yellow" },
}
---------- -------- -------- --------

local colorCmd = "colorscheme " .. theme

hpcall(vim.cmd, colorCmd, {
	onErr = function()
		vim.notify(colorCmd .. " not found!")
		vim.cmd([[colorscheme default]])
	end,
})
end
}

