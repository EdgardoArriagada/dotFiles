local X = '<Esc>"xpa' -- X is the variable to log

local function doLog(msg, _after)
	local after = _after or ""
	Execute('normal<Esc>"xyiwo' .. msg .. "<Esc><left><left>" .. after)
end

local function jsLoggerSP()
	doLog("console.log('le " .. X .. "', JSON.stringify(" .. X .. ", null, 2));")
end

local function jsLogger()
	doLog("console.log('le " .. X .. "', " .. X .. ");")
end

local function luaLogger()
	doLog("print('le " .. X .. "', " .. X .. ");")
end

local function rustLogger()
	doLog('println!("le ' .. X .. ': {}", ' .. X .. ");")
end

local function bashLogger()
	doLog('echo "le ' .. X .. ": ${" .. X .. '}";', "b")
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
	["ts"] = jsLoggerSP,
	["jsx"] = jsLoggerSP,
	["tsx"] = jsLoggerSP,
	[""] = noExtensionLogger,
}

local function executeLogger(dictionary, onErrMsg)
	local extension = vim.fn.expand("%:e")
	local fun = dictionary[extension]

	if fun == nil then
		print(onErrMsg .. " for '" .. extension .. "' extension")
		return
	end

	fun()
end

function Logger()
	executeLogger(extensionToFunction, "No logger function")
end

function LoggerSP()
	executeLogger(extensionToFunctionSP, "No SP logger function")
end
