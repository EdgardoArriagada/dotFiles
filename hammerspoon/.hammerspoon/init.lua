local m = require("utils")

-- Switch alacritty
hs.hotkey.bind("§", "§", function()
	local APP_NAME = "Alacritty"

	local alacritty = hs.application.get(APP_NAME)

	if alacritty ~= nil and alacritty:isFrontmost() then
		alacritty:hide()
		return
	end

	if alacritty == nil and hs.application.launchOrFocus(APP_NAME) then
		m.onAppLaunch(APP_NAME, m.visualizeApp)
		return
	end

	if alacritty ~= nil then
		m.visualizeApp(alacritty)
		return
	end
end)
