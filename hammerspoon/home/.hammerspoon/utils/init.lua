M = {}

local alert = hs.alert.show

local function removeFullScreen(win)
	if win:isFullScreen() then
		win:toggleFullScreen()
	end
end

local function resizeWindowToScreenFrame(win)
	win:setFrame(hs.screen.mainScreen():frame(), 0)
end

local function ensureAppMainWindow(app)
	local mw = app:mainWindow()
	if mw == nil then
		hs.application.open(app:name())
		return app:mainWindow()
	end

	return mw
end

local function visualizeAppInScreenFrame(app)
	app:activate(true)

	local win = ensureAppMainWindow(app)
	if win == nil then
		return
	end

	resizeWindowToScreenFrame(win)
	removeFullScreen(win)
end

local function onAppLaunch(appName, callback)
	local appWatcher = nil

	appWatcher = hs.application.watcher.new(function(name, event, app)
		if name == appName and event == hs.application.watcher.launched then
			visualizeAppInScreenFrame(app)
			callback(app)
			appWatcher:stop()
		end
	end)

	appWatcher:start()
end

local function ensureAppFrontmost(app)
	ensureAppMainWindow(app)
	return app:setFrontmost()
end

local function toggleApp(app)
	if app:isFrontmost() then
		app:hide()
	else
		ensureAppFrontmost(app)
	end
end

local function launchApp(appName)
	if hs.application.launchOrFocus(appName) then
		return onAppLaunch(appName, visualizeAppInScreenFrame)
	end
end

local function launchAppAndAlertLaunch(appName)
	alert("Launching " .. appName .. "...")
	return launchApp(appName)
end

local function alertNotLaunchedApp(appName)
	return alert(appName .. " not launched")
end

local function handleApp(appName, handlers)
	local app = hs.application.get(appName)

	if app == nil then
		handlers.onNotLaunched(appName)
	else
		handlers.onOk(app)
	end
end

local weakFocusHandlers = {
	onOk = ensureAppFrontmost,
	onNotLaunched = alertNotLaunchedApp,
}

local focusAppHandlers = {
	onOk = ensureAppFrontmost,
	onNotLaunched = launchAppAndAlertLaunch,
}

local toggleAppHandlers = {
	onOk = toggleApp,
	onNotLaunched = launchAppAndAlertLaunch,
}

-- TO EXPORT

M.weakFocus = function(appName)
	return function()
		handleApp(appName, weakFocusHandlers)
	end
end

M.focusApp = function(appName)
	return function()
		handleApp(appName, focusAppHandlers)
	end
end

M.toggleApp = function(appName)
	return function()
		handleApp(appName, toggleAppHandlers)
	end
end

-- Works a little buggy
M.hideAllApps = function()
	local apps = hs.application.runningApplications()

	for _ = 1, 2 do
		for _, app in pairs(apps) do
			app:hide()
		end
	end
end

return M
