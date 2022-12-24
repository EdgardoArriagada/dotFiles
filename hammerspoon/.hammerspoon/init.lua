local utils = require("utils")
local toggleApp, launchApp = utils.toggleApp, utils.launchApp
local ALACRITTY = "Alacritty"

-- Switch alacritty
hs.hotkey.bind({}, "§", function()
	local alacritty = hs.application.get(ALACRITTY)

	if alacritty == nil then
		return launchApp(ALACRITTY)
	end

	toggleApp(alacritty)
end)
