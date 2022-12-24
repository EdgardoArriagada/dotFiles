local utils = require("utils")
local visualizeApp, onAppLaunch = utils.visualizeApp, utils.onAppLaunch

local ALACRITTY = "Alacritty"

-- Switch alacritty
hs.hotkey.bind({}, "§", function()
	local alacritty = hs.application.get(ALACRITTY)

	if alacritty ~= nil then
		if alacritty:isFrontmost() then
			return alacritty:hide()
		end

		return visualizeApp(alacritty)
	end

	if alacritty == nil and hs.application.launchOrFocus(ALACRITTY) then
		return onAppLaunch(ALACRITTY, visualizeApp)
	end
end)
