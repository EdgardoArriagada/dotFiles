local u = require("zsb.customPluggins.logger.utils")
local l = u.doLog

local M = {}

M.jsLogger = function(slot)
	l("console.log('le " .. slot .. "', " .. slot .. ");")
end

M.jsLoggerSP = function(slot)
	l(
		"console.log('le "
			.. slot
			.. "', JSON.stringify("
			.. slot
			.. ", (_, v) => (typeof v === 'function' ? `fn ${v.name}(...)` : v), 2));"
	)
end

M.tsLoggerSP = function(slot)
	l(
		"console.log('le "
			.. slot
			.. "', JSON.stringify("
			.. slot
			.. ", (_, v: string) => (typeof v === 'function' ? `fn ${(v as Function).name}(...)` : v), 2));"
	)
end

M.luaLogger = function(slot)
	l("print('le " .. slot .. "', " .. slot .. ");")
end

M.luaLoggerSP = function(slot)
	l("print('le " .. slot .. ":', vim.inspect(" .. slot .. "));")
end

M.rustLogger = function(slot)
	l('println!("le ' .. slot .. ': {}", ' .. slot .. ");")
end

M.rustLoggerSp = function(slot)
	l('println!("le ' .. slot .. ': {:?}", ' .. slot .. ");")
end

M.bashLogger = function(slot)
	l('echo "le ' .. slot .. ": ${" .. slot .. '}";', { after = "b" })
end

return M
