-- https://github.com/kristijanhusak/vim-dadbod-ui#mappings
local toggleDrawerWith = MakeMultimap("n", "<PLUG>(DBUI_SelectLine)", { buffer = 0 })

toggleDrawerWith({ "l", "h", "<CR>" })
