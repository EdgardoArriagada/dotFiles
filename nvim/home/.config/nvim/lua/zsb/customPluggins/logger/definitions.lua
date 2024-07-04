local u = require("zsb.customPluggins.logger.utils")
local sqo = u.withSingleQuotesOnly
local dqo = u.withDoubleQuotesOnly
local l = u.doLog

local M = {}

M.js = function(slot)
	l("console.log('le " .. dqo(slot) .. "', " .. slot .. ");")
end

M.jsSP = function(slot)
	l(
		"console.log('le "
			.. dqo(slot)
			.. "', JSON.stringify("
			.. slot
			.. ", (_, v) => (typeof v === 'function' ? `fn ${v.name}(...)` : v), 2));"
	)
end

M.tsSP = function(slot)
	l(
		"console.log('le "
			.. dqo(slot)
			.. "', JSON.stringify("
			.. slot
			.. ", (_, v: string) => (typeof v === 'function' ? `fn ${(v as Function).name}(...)` : v), 2));"
	)
end

M.lua = function(slot)
	l("print('le " .. dqo(slot) .. "', " .. slot .. ");")
end

M.luaSP = function(slot)
	l("print('le " .. dqo(slot) .. ":', vim.inspect(" .. slot .. "));")
end

M.rust = function(slot)
	l('println!("le ' .. sqo(slot) .. ': {}", ' .. slot .. ");")
end

M.rustSp = function(slot)
	l('println!("le ' .. sqo(slot) .. ': {:?}", ' .. slot .. ");")
end

M.bash = function(slot)
	l('echo "le ' .. sqo(slot) .. ": ${" .. slot .. '}";', { after = "b" })
end

M.go = function(slot)
	l('fmt.Println("le ' .. sqo(slot) .. '", ' .. slot .. ")")
end

return M
