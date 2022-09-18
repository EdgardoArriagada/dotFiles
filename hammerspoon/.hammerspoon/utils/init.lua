local spaces = require("hs.spaces")

M = {}

local function setWinFrame(win)
	local scrFrame = hs.screen.mainScreen():fullFrame()
	local winFrame = win:frame()

	winFrame.w = scrFrame.w
	winFrame.y = scrFrame.y
	winFrame.x = scrFrame.x

	win:setFrame(winFrame, 0)
end

local function getMainWindow(app)
	local win = nil

	while win == nil do
		win = app:mainWindow()
	end

	return win
end

function M.onAppLaunch(appName, callback)
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

function M.visualizeApp(app)
	local currSpaceId = spaces.activeSpaceOnScreen()
	local win = getMainWindow(app)

	local fullScreen = not win:isStandard()

	if fullScreen then
		hs.eventtap.keyStroke("cmd", "return", 0, app)
	end

	setWinFrame(win)

	spaces.moveWindowToSpace(win, currSpaceId)
	spaces.spaceDisplay(currSpaceId)

	if fullScreen then
		hs.eventtap.keyStroke("cmd", "return", 0, app)
	end

	win:focus()
end

return M
