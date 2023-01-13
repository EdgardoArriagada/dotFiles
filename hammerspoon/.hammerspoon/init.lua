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

-- for more apps, see /Applications
hs.hotkey.bind({}, "§", toggleApp("Alacritty"))
hs.hotkey.bind({ "command" }, "1", focusApp("Slack"))
hs.hotkey.bind({ "command" }, "2", focusApp("Google Chrome"))
hs.hotkey.bind({ "command" }, "3", focusApp("IntelliJ IDEA"))
hs.hotkey.bind({ "command" }, "9", focusApp("Spotify"))
