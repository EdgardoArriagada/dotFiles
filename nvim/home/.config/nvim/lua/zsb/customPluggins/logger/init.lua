local u = require("zsb.customPluggins.logger.utils")
local d = require("zsb.customPluggins.logger.definitions")

-- [extension] = { normal, SP }
local extensionToFunction = {
	["js"] = { d.js, d.jsSP },
	["ts"] = { d.js, d.tsSP },
	["jsx"] = { d.js, d.jsSP },
	["tsx"] = { d.js, d.tsSP },
	["lua"] = { d.lua, d.luaSP },
	["rs"] = { d.rust, d.rustSp },
	["zsh"] = { d.bash, d.bash },
	["go"] = { d.go, d.go },
}

function Logger()
	u.executeLogger(extensionToFunction, u.TYPE.NORMAL, "No logger function")
end

function LoggerSP()
	u.executeLogger(extensionToFunction, u.TYPE.SP, "No SP logger function")
end
