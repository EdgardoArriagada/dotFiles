local el = '<Esc>"xpa'

local function doLog(msg, _after)
	local after = _after or ""
	Execute('normal<Esc>"xyiwo' .. msg .. "<Esc><left><left>" .. after)
end

local function jsLoggerSP()
	doLog("console.log('le " .. el .. "', JSON.stringify(" .. el .. ", null, 2));")
end

local function jsLogger()
	doLog("console.log('le " .. el .. "', " .. el .. ");")
end

local function luaLogger()
	doLog("print('le " .. el .. "', " .. el .. ");")
end

local function rustLogger()
	doLog('println!("le ' .. el .. '", ' .. el .. ");")
end

local function bashLogger()
	doLog('echo "le ' .. el .. ": ${" .. el .. '}";', "b")
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

local function executeLogger(dictionary)
	local extension = vim.fn.expand("%:e")
	local fun = dictionary[extension]

	if fun == nil then
		print("No logger function for '" .. extension .. "' extension")
		return
	end

	fun()
end

function Logger()
	executeLogger(extensionToFunction)
end

function LoggerSP()
	executeLogger(extensionToFunctionSP)
end
