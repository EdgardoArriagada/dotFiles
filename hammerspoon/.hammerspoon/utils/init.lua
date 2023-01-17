local spaces = require("hs.spaces")

M = {}

local function resizeWindowToScreenFrame(win)
	local scrFrame = hs.screen.mainScreen():frame()
	win:setFrame(scrFrame, 0)
end

local function onAppLaunch(appName, callback)
	local appWatcher = nil

	appWatcher = hs.application.watcher.new(function(name, event, app)
		if name == appName and event == hs.application.watcher.launched then
			callback(app)
			appWatcher:stop()
		end
	end)

	appWatcher:start()
end

local function getAppMainWindow(app)
	if app:mainWindow() == nil then
		hs.application.open(app:name())
	end

	return app:mainWindow()
end

local function displayWindowInCurrentSpace(win)
	local currSpaceId = spaces.activeSpaceOnScreen()

	spaces.moveWindowToSpace(win, currSpaceId)
	spaces.spaceDisplay(currSpaceId)
end

local function visualizeAppInScreenFrame(app)
	local win = getAppMainWindow(app)

	resizeWindowToScreenFrame(win)
	displayWindowInCurrentSpace(win)

	if win:isFullScreen() then
		win:toggleFullScreen()
	end

	win:focus()
end

local function toggleApp(app)
	if app:isFrontmost() then
		app:hide()
	else
		visualizeAppInScreenFrame(app)
	end
end

local function launchApp(appName)
	if hs.application.launchOrFocus(appName) then
		return onAppLaunch(appName, visualizeAppInScreenFrame)
	end
end

local function handleApp(appName, handleOk, hanleNotOk)
	local app = hs.application.get(appName)

	if app == nil then
		hanleNotOk(appName)
	else
		handleOk(app)
	end
end

local function launchNilApp(appName)
	hs.alert.show("Launching " .. appName .. "...")
	return launchApp(appName)
end

local function alertNotLaunchedApp(appName)
	return hs.alert.show(appName .. " not launched")
end

M.weakFocus = function(appName)
	handleApp(appName, visualizeAppInScreenFrame, alertNotLaunchedApp)
end

M.focusApp = function(appName)
	handleApp(appName, visualizeAppInScreenFrame, launchNilApp)
end

M.toggleApp = function(appName)
	handleApp(appName, toggleApp, launchNilApp)
end

return M
