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

--- @param mode? "v"
function Logger(mode)
	u.executeLogger(extensionToFunction, "No logger function", mode)
end

--- @param mode? "v"
function LoggerSP(mode)
	u.executeLogger(extensionToFunctionSP, "No SP logger function", mode)
end
