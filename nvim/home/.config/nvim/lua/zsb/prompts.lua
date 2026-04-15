local M = {}

M.debug = {
	desc = "Debug",
	get = function()
		return [[
- add debug logs writing to the filesystem any information you think is neccessary
- ask me to run the script again and I will tell you when is done so you can check the logs
- lets repeat untill we find the issue]]
	end,
}

return M
