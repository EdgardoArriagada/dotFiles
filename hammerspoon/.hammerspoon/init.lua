local M = require("utils")
local visualizeApp, onAppLaunch = M.visualizeApp, M.onAppLaunch

-- Switch alacritty
hs.hotkey.bind("§", "§", function()
	local APP_NAME = "Alacritty"

	local alacritty = hs.application.get(APP_NAME)

	if alacritty ~= nil and alacritty:isFrontmost() then
		alacritty:hide()
		return
	end

	if alacritty == nil and hs.application.launchOrFocus(APP_NAME) then
		onAppLaunch(APP_NAME, visualizeApp)
		return
	end

	if alacritty ~= nil then
		visualizeApp(alacritty)
		return
	end
end)
