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

local function visualizeApp(app)
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

local function toggleApp(app)
	if app:isFrontmost() then
		app:hide()
	else
		visualizeApp(app)
	end
end

local function launchApp(appName)
	if hs.application.launchOrFocus(appName) then
		return onAppLaunch(appName, visualizeApp)
	end
end

local function handleApp(appName, callback)
	local app = hs.application.get(appName)

	if app == nil then
		hs.alert.show("Launching " .. appName .. "...")
		return launchApp(appName)
	end

	callback(app)
end

M.weakFocus = function(appName)
	local app = hs.application.get(appName)

	if app == nil then
		hs.alert.show(appName .. " has not been launched yet")
		return
	end

	visualizeApp(app)
end

M.focusApp = function(appName)
	handleApp(appName, visualizeApp)
end

M.toggleApp = function(appName)
	handleApp(appName, toggleApp)
end

return M
