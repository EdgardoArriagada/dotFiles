local spaces = require("hs.spaces")

function OnAppLaunch(appName, callback)
	local appWatcher = nil

	appWatcher = hs.application.watcher.new(function(name, event, app)
		if name == appName and event == hs.application.watcher.launched then
			app:hide()
			callback(app)
			appWatcher:stop()
		end
	end)

	appWatcher:start()
end

function SetWinFrame(win)
	local scrFrame = hs.screen.mainScreen():fullFrame()

	local winFrame = win:frame()
	winFrame.w = scrFrame.w
	winFrame.y = scrFrame.y
	winFrame.x = scrFrame.x
	win:setFrame(winFrame, 0)
end

function GetMainWindow(app)
	local win = nil

	while win == nil do
		win = app:mainWindow()
	end

	return win
end

function VisualizeApp(app)
	local currSpaceId = spaces.activeSpaceOnScreen()
	local win = GetMainWindow(app)

	local fullScreen = not win:isStandard()

	if fullScreen then
		hs.eventtap.keyStroke("cmd", "return", 0, app)
	end

	SetWinFrame(win)

	spaces.moveWindowToSpace(win, currSpaceId)
	spaces.spaceDisplay(currSpaceId)

	if fullScreen then
		hs.eventtap.keyStroke("cmd", "return", 0, app)
	end

	win:focus()
end

-- Switch alacritty
hs.hotkey.bind("§", "§", function()
	local APP_NAME = "Alacritty"

	local alacritty = hs.application.get(APP_NAME)

	if alacritty ~= nil and alacritty:isFrontmost() then
		alacritty:hide()
		return
	end

	if alacritty == nil and hs.application.launchOrFocus(APP_NAME) then
		OnAppLaunch(APP_NAME, VisualizeApp)
		return
	end

	if alacritty ~= nil then
		VisualizeApp(alacritty)
		return
	end
end)
