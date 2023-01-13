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

local function weakFocus(appName)
	return function()
		utils.weakFocus(appName)
	end
end

local cmd2 = { "command", "ctrl" }

-- for more apps, see /Applications
hs.hotkey.bind({}, "§", toggleApp("Alacritty"))
hs.hotkey.bind(cmd2, "1", focusApp("Slack"))
hs.hotkey.bind(cmd2, "2", focusApp("Google Chrome"))
hs.hotkey.bind(cmd2, "3", weakFocus("IntelliJ IDEA"))
hs.hotkey.bind(cmd2, "9", focusApp("Spotify"))
