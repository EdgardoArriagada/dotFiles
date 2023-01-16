local spaces = require("hs.spaces")

M = {}

local function copyMainScreenFullFrame(win)
	local scrFrame = hs.screen.mainScreen():fullFrame()
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

local function visualizeApp(app)
	local currSpaceId = spaces.activeSpaceOnScreen()
	local win = getAppMainWindow(app)

	copyMainScreenFullFrame(win)

	spaces.moveWindowToSpace(win, currSpaceId)
	spaces.spaceDisplay(currSpaceId)

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
		return hs.alert.show(appName .. " has not been launched yet")
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
