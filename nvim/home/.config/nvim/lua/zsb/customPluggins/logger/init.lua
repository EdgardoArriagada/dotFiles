local u = require("zsb.customPluggins.logger.utils")
local d = require("zsb.customPluggins.logger.definitions")

local extensionToFunction = {
	["js"] = d.jsLogger,
	["ts"] = d.jsLogger,
	["jsx"] = d.jsLogger,
	["tsx"] = d.jsLogger,
	["lua"] = d.luaLogger,
	["rs"] = d.rustLogger,
	["zsh"] = d.bashLogger,
}

local extensionToFunctionSP = {
	["js"] = d.jsLoggerSP,
	["ts"] = d.tsLoggerSP,
	["jsx"] = d.jsLoggerSP,
	["tsx"] = d.tsLoggerSP,
	["lua"] = d.luaLoggerSP,
	["rs"] = d.rustLoggerSp,
}

function Logger(mode)
	u.executeLogger(extensionToFunction, mode, "No logger function")
end

function LoggerSP(mode)
	u.executeLogger(extensionToFunctionSP, mode, "No SP logger function")
end
