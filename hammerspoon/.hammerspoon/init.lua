local utils = require("utils")
local visualizeApp, onAppLaunch = utils.visualizeApp, utils.onAppLaunch

local ALACRITTY = "Alacritty"

-- Switch alacritty
hs.hotkey.bind("§", "§", function()
	local alacritty = hs.application.get(ALACRITTY)

	if alacritty ~= nil and alacritty:isFrontmost() then
		alacritty:hide()
		return
	end

	if alacritty == nil and hs.application.launchOrFocus(ALACRITTY) then
		onAppLaunch(ALACRITTY, visualizeApp)
		return
	end

	if alacritty ~= nil then
		visualizeApp(alacritty)
		return
	end
end)
