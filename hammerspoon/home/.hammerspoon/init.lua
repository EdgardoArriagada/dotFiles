local utils = require("utils")
local hideAllApps = utils.hideAllApps
local focusApp = utils.focusApp
local toggleApp = utils.toggleApp
local weakFocus = utils.weakFocus

local cmd2 = { "command", "ctrl" }

-- for more apps, run
-- $ ls /Applications
hs.hotkey.bind({}, "§", toggleApp("Alacritty"))
hs.hotkey.bind(cmd2, "1", weakFocus("Slack"))
hs.hotkey.bind(cmd2, "2", focusApp("Google Chrome"))
hs.hotkey.bind(cmd2, "3", weakFocus("IntelliJ IDEA"))
hs.hotkey.bind(cmd2, "4", weakFocus("Insomnia"))
hs.hotkey.bind(cmd2, "9", focusApp("Spotify"))
hs.hotkey.bind(cmd2, "h", hideAllApps)
