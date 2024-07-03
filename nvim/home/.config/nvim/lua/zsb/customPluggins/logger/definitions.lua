local u = require("zsb.customPluggins.logger.utils")
local l = u.doLog

local M = {}

M.js = function(slot)
	l("console.log('le " .. slot .. "', " .. slot .. ");")
end

M.jsSP = function(slot)
	l(
		"console.log('le "
			.. slot
			.. "', JSON.stringify("
			.. slot
			.. ", (_, v) => (typeof v === 'function' ? `fn ${v.name}(...)` : v), 2));"
	)
end

M.tsSP = function(slot)
	l(
		"console.log('le "
			.. slot
			.. "', JSON.stringify("
			.. slot
			.. ", (_, v: string) => (typeof v === 'function' ? `fn ${(v as Function).name}(...)` : v), 2));"
	)
end

M.lua = function(slot)
	l("print('le " .. slot .. "', " .. slot .. ");")
end

M.luaSP = function(slot)
	l("print('le " .. slot .. ":', vim.inspect(" .. slot .. "));")
end

M.rust = function(slot)
	l('println!("le ' .. slot .. ': {}", ' .. slot .. ");")
end

M.rustSp = function(slot)
	l('println!("le ' .. slot .. ': {:?}", ' .. slot .. ");")
end

M.bash = function(slot)
	l('echo "le ' .. slot .. ": ${" .. slot .. '}";', { after = "b" })
end

M.go = function(slot)
	l('fmt.Println("le ' .. slot .. '", ' .. slot .. ")")
end

return M
