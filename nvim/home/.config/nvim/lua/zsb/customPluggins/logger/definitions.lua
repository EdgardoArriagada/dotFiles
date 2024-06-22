local u = require("zsb.customPluggins.logger.utils")

local M = {}

M.jsLogger = function(mode)
	local slot = u.getSlot(mode)
	u.doLog("console.log('le " .. slot .. "', " .. slot .. ");")
end

M.jsLoggerSP = function(mode)
	local slot = u.getSlot(mode)
	u.doLog(
		"console.log('le "
			.. slot
			.. "', JSON.stringify("
			.. slot
			.. ", (_, v) => (typeof v === 'function' ? `fn ${v.name}(...)` : v), 2));"
	)
end

M.tsLoggerSP = function(mode)
	local slot = u.getSlot(mode)
	u.doLog(
		"console.log('le "
			.. slot
			.. "', JSON.stringify("
			.. slot
			.. ", (_, v: string) => (typeof v === 'function' ? `fn ${(v as Function).name}(...)` : v), 2));"
	)
end

M.luaLogger = function(mode)
	local slot = u.getSlot(mode)
	u.doLog("print('le " .. slot .. "', " .. slot .. ");")
end

M.luaLoggerSP = function(mode)
	local slot = u.getSlot(mode)
	u.doLog("print('le " .. slot .. ":', vim.inspect(" .. slot .. "));")
end

M.rustLogger = function(mode)
	local slot = u.getSlot(mode)
	u.doLog('println!("le ' .. slot .. ': {}", ' .. slot .. ");")
end

M.rustLoggerSp = function(mode)
	local slot = u.getSlot(mode)
	u.doLog('println!("le ' .. slot .. ': {:?}", ' .. slot .. ");")
end

M.bashLogger = function(mode)
	local slot = u.getSlot(mode)
	u.doLog('echo "le ' .. slot .. ": ${" .. slot .. '}";', { after = "b" })
end

return M
