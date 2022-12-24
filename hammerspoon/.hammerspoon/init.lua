local utils = require("utils")
local visualizeApp = utils.visualizeApp
local onAppLaunch = utils.onAppLaunch
local toggleApp = utils.toggleApp

local ALACRITTY = "Alacritty"

-- Switch alacritty
hs.hotkey.bind({}, "§", function()
	local alacritty = hs.application.get(ALACRITTY)

	if alacritty ~= nil then
		return toggleApp(alacritty)
	end

	if alacritty == nil and hs.application.launchOrFocus(ALACRITTY) then
		return onAppLaunch(ALACRITTY, visualizeApp)
	end
end)
