local u = require("zsb.customPluggins.logger.utils")

local function jsLogger(mode)
	local slot = u.getSlot(mode)
	u.doLog("console.log('le " .. slot .. "', " .. slot .. ");")
end

local function jsLoggerSP(mode)
	local slot = u.getSlot(mode)
	u.doLog(
		"console.log('le "
			.. slot
			.. "', JSON.stringify("
			.. slot
			.. ", (_, v) => (typeof v === 'function' ? `fn ${v.name}(...)` : v), 2));"
	)
end

local function tsLoggerSP(mode)
	local slot = u.getSlot(mode)
	u.doLog(
		"console.log('le "
			.. slot
			.. "', JSON.stringify("
			.. slot
			.. ", (_, v: string) => (typeof v === 'function' ? `fn ${(v as Function).name}(...)` : v), 2));"
	)
end

local function luaLogger(mode)
	local slot = u.getSlot(mode)
	u.doLog("print('le " .. slot .. "', " .. slot .. ");")
end

local function luaLoggerSP(mode)
	local slot = u.getSlot(mode)
	u.doLog("print('le " .. slot .. ":', vim.inspect(" .. slot .. "));")
end

local function rustLogger(mode)
	local slot = u.getSlot(mode)
	u.doLog('println!("le ' .. slot .. ': {}", ' .. slot .. ");")
end

local function rustLoggerSp(mode)
	local slot = u.getSlot(mode)
	u.doLog('println!("le ' .. slot .. ': {:?}", ' .. slot .. ");")
end

local function bashLogger(mode)
	local slot = u.getSlot(mode)
	u.doLog('echo "le ' .. slot .. ": ${" .. slot .. '}";', { after = "b" })
end

local noExtensionLogger = bashLogger

local extensionToFunction = {
	["js"] = jsLogger,
	["ts"] = jsLogger,
	["jsx"] = jsLogger,
	["tsx"] = jsLogger,
	["lua"] = luaLogger,
	["rs"] = rustLogger,
	["zsh"] = bashLogger,
	[""] = noExtensionLogger,
}

local extensionToFunctionSP = {
	["js"] = jsLoggerSP,
	["ts"] = tsLoggerSP,
	["jsx"] = jsLoggerSP,
	["tsx"] = tsLoggerSP,
	["lua"] = luaLoggerSP,
	["rs"] = rustLoggerSp,
	[""] = noExtensionLogger,
}

function Logger(mode)
	u.executeLogger(extensionToFunction, mode, "No logger function")
end

function LoggerSP(mode)
	u.executeLogger(extensionToFunctionSP, mode, "No SP logger function")
end
