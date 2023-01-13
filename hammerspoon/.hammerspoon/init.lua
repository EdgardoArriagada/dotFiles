local utils = require("utils")

local function focusApp(appName)
	return function()
		utils.focusApp(appName)
	end
end

local function toggleApp(appName)
	return function()
		utils.toggleApp(appName)
	end
end

hs.hotkey.bind({}, "§", toggleApp("Alacritty"))
hs.hotkey.bind({ "command" }, "1", focusApp("Slack"))
hs.hotkey.bind({ "command" }, "2", focusApp("Google Chrome"))
