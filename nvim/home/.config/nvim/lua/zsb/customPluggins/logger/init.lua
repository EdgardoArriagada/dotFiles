local u = require("zsb.customPluggins.logger.utils")
local d = require("zsb.customPluggins.logger.definitions")

local extensionToFunction = {
	["js"] = d.js,
	["ts"] = d.js,
	["jsx"] = d.js,
	["tsx"] = d.js,
	["lua"] = d.lua,
	["rs"] = d.rust,
	["zsh"] = d.bash,
	["go"] = d.go,
}

local extensionToFunctionSP = {
	["js"] = d.jsSP,
	["ts"] = d.tsSP,
	["jsx"] = d.jsSP,
	["tsx"] = d.tsSP,
	["lua"] = d.luaSP,
	["rs"] = d.rustSp,
	["zsh"] = d.bash,
	["go"] = d.go,
}

function Logger()
	u.executeLogger(extensionToFunction, "No logger function")
end

function LoggerSP()
	u.executeLogger(extensionToFunctionSP, "No SP logger function")
end
