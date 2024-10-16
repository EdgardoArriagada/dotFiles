local u = require("zsb.customPluggins.logger.utils")
local d = require("zsb.customPluggins.logger.definitions")

local NORMAL = 1
local SP = 2

-- [filetype] = { normal, SP }
local extensionToFunction = {
	["javascript"] = { d.js, d.jsSP },
	["typescript"] = { d.js, d.tsSP },
	["javascriptreact"] = { d.js, d.jsSP },
	["typescriptreact"] = { d.js, d.tsSP },
	["lua"] = { d.lua, d.luaSP },
	["rust"] = { d.rust, d.rustSp },
	["zsh"] = { d.bash, d.bash },
	["go"] = { d.go, d.go },
	["python"] = { d.py, d.py },
}

function Logger()
	u.executeLogger(extensionToFunction, NORMAL, "No logger function")
end

function LoggerSP()
	u.executeLogger(extensionToFunction, SP, "No SP logger function")
end
