local u = require("zsb.customPluggins.logger.utils")

local M = {}

M.jsLogger = function(slot)
	u.doLog("console.log('le " .. slot .. "', " .. slot .. ");")
end

M.jsLoggerSP = function(slot)
	u.doLog(
		"console.log('le "
			.. slot
			.. "', JSON.stringify("
			.. slot
			.. ", (_, v) => (typeof v === 'function' ? `fn ${v.name}(...)` : v), 2));"
	)
end

M.tsLoggerSP = function(slot)
	u.doLog(
		"console.log('le "
			.. slot
			.. "', JSON.stringify("
			.. slot
			.. ", (_, v: string) => (typeof v === 'function' ? `fn ${(v as Function).name}(...)` : v), 2));"
	)
end

M.luaLogger = function(slot)
	u.doLog("print('le " .. slot .. "', " .. slot .. ");")
end

M.luaLoggerSP = function(slot)
	u.doLog("print('le " .. slot .. ":', vim.inspect(" .. slot .. "));")
end

M.rustLogger = function(slot)
	u.doLog('println!("le ' .. slot .. ': {}", ' .. slot .. ");")
end

M.rustLoggerSp = function(slot)
	u.doLog('println!("le ' .. slot .. ': {:?}", ' .. slot .. ");")
end

M.bashLogger = function(slot)
	u.doLog('echo "le ' .. slot .. ": ${" .. slot .. '}";', { after = "b" })
end

return M
