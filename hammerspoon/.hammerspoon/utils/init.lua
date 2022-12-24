local spaces = require("hs.spaces")

M = {}

local function copyMainScreenFullFrame(win)
	local scrFrame = hs.screen.mainScreen():fullFrame()
	local winFrame = win:frame()

	winFrame.w = scrFrame.w
	winFrame.y = scrFrame.y
	winFrame.x = scrFrame.x

	win:setFrame(winFrame, 0)
end

local function getMainWindow(app)
	local result = nil

	while result == nil do
		result = app:mainWindow()
	end

	return result
end

function M.onAppLaunch(appName, callback)
	local appWatcher = nil

	appWatcher = hs.application.watcher.new(function(name, event, app)
		if name == appName and event == hs.application.watcher.launched then
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

	copyMainScreenFullFrame(win)

	spaces.moveWindowToSpace(win, currSpaceId)
	spaces.spaceDisplay(currSpaceId)

	if fullScreen then
		hs.eventtap.keyStroke("cmd", "return", 0, app)
	end

	win:focus()
end

function M.toggleApp(app)
	if app:isFrontmost() then
		app:hide()
	else
		M.visualizeApp(app)
	end
end

return M
