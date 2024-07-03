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
	["go"] = d.goLogger,
}

local extensionToFunctionSP = {
	["js"] = d.jsLoggerSP,
	["ts"] = d.tsLoggerSP,
	["jsx"] = d.jsLoggerSP,
	["tsx"] = d.tsLoggerSP,
	["lua"] = d.luaLoggerSP,
	["rs"] = d.rustLoggerSp,
	["zsh"] = d.bashLogger,
	["go"] = d.goLogger,
}

function Logger()
	u.executeLogger(extensionToFunction, "No logger function")
end

function LoggerSP()
	u.executeLogger(extensionToFunctionSP, "No SP logger function")
end
