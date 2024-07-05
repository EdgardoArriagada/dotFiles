local u = require("zsb.customPluggins.logger.utils")
local d = require("zsb.customPluggins.logger.definitions")

local NORMAL = 1
local SP = 2

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
	u.executeLogger(extensionToFunction, NORMAL, "No logger function")
end

function LoggerSP()
	u.executeLogger(extensionToFunction, SP, "No SP logger function")
end
