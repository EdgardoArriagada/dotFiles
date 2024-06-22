local X = '<Esc>"xpa' -- X is the variable to log

local function getSlot(mode)
	if mode == "v" then
		return GetVisualSelection()
	else
		return X
	end
end

local function doLog(logStatement, _opts)
	local opts = _opts or {}

	local after = opts.after or ""
	Execute('normal<Esc>"xyiwo' .. logStatement .. "<Esc><left><left>" .. after)
end

local function jsLogger(mode)
	local slot = getSlot(mode)
	doLog("console.log('le " .. slot .. "', " .. slot .. ");")
end

local function jsLoggerSP(mode)
	local slot = getSlot(mode)
	doLog(
		"console.log('le "
			.. slot
			.. "', JSON.stringify("
			.. slot
			.. ", (_, v) => (typeof v === 'function' ? `fn ${v.name}(...)` : v), 2));"
	)
end

local function tsLoggerSP(mode)
	local slot = getSlot(mode)
	doLog(
		"console.log('le "
			.. slot
			.. "', JSON.stringify("
			.. slot
			.. ", (_, v: string) => (typeof v === 'function' ? `fn ${(v as Function).name}(...)` : v), 2));"
	)
end

local function luaLogger(mode)
	local slot = getSlot(mode)
	doLog("print('le " .. slot .. "', " .. slot .. ");")
end

local function luaLoggerSP(mode)
	local slot = getSlot(mode)
	doLog("print('le " .. slot .. ":', vim.inspect(" .. slot .. "));")
end

local function rustLogger(mode)
	local slot = getSlot(mode)
	doLog('println!("le ' .. slot .. ': {}", ' .. slot .. ");")
end

local function rustLoggerSp(mode)
	local slot = getSlot(mode)
	doLog('println!("le ' .. slot .. ': {:?}", ' .. slot .. ");")
end

local function bashLogger(mode)
	local slot = getSlot(mode)
	doLog('echo "le ' .. slot .. ": ${" .. slot .. '}";', { after = "b" })
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

local function executeLogger(dictionary, mode, onErrMsg)
	local extension = vim.fn.expand("%:e")
	local fun = dictionary[extension]

	if fun == nil then
		print(onErrMsg .. " for '" .. extension .. "' extension")
		return
	end

	fun(mode)
end

function Logger(mode)
	executeLogger(extensionToFunction, mode, "No logger function")
end

function LoggerSP(mode)
	executeLogger(extensionToFunctionSP, mode, "No SP logger function")
end
