-- for this script to work:
-- remember to enable "Accessibility" permissions to Hammerspoon 
-- in the "Security & Privacy" panel in OSX System Preferences.

local u = require("utils")

local cmd2 = { "command", "ctrl" }

-- for more apps, run
-- $ ls /Applications
hs.hotkey.bind({}, "forwarddelete", u.toggleApp("Ghostty"))
hs.hotkey.bind({}, "§", u.toggleApp("Ghostty"))
hs.hotkey.bind(cmd2, "1", u.weakFocus("Slack"))
hs.hotkey.bind(cmd2, "2", u.focusApp("Google Chrome"))
hs.hotkey.bind(cmd2, "3", u.weakFocus("IntelliJ IDEA"))
hs.hotkey.bind(cmd2, "4", u.weakFocus("Postman"))
hs.hotkey.bind(cmd2, "5", u.weakFocus("Neovide"))
hs.hotkey.bind(cmd2, "9", u.focusApp("Spotify"))
hs.hotkey.bind(cmd2, "h", u.hideAllApps)
