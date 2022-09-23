local utils = require("utils")
local visualizeApp, onAppLaunch = utils.visualizeApp, utils.onAppLaunch

local ALACRITTY = "Alacritty"

-- Switch alacritty
hs.hotkey.bind({}, "§", function()
	local alacritty = hs.application.get(ALACRITTY)

	if alacritty ~= nil and not alacritty:isHidden() then
		alacritty:hide()
		return
	end

	if alacritty ~= nil then
		visualizeApp(alacritty)
		return
	end

	if alacritty == nil and hs.application.launchOrFocus(ALACRITTY) then
		onAppLaunch(ALACRITTY, visualizeApp)
		return
	end
end)

-- Hide alacritty if not in focus
hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function(window, appName)
	local alacritty = hs.application.get(ALACRITTY)

	if alacritty ~= nil then
		alacritty:hide()
	end
end)
