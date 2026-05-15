local M = {}

local alert = hs.alert.show

local function removeFullScreen(win)
	if win:isFullScreen() then
		win:toggleFullScreen()
	end
end

local function resizeWindowToScreenFrame(win)
	win:setFrame(win:screen():frame(), 0)
end

local function ensureAppMainWindow(app)
	local mw = app:mainWindow()
	if mw == nil then
		hs.application.open(app:name())
		return app:mainWindow()
	end

	return mw
end

local function presentApp(app)
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
	local timer = nil

	appWatcher = hs.application.watcher.new(function(name, event, app)
		if name == appName and event == hs.application.watcher.launched then
			if timer then
				timer:stop()
			end
			callback(app)
			appWatcher:stop()
		end
	end)

	timer = hs.timer.doAfter(10, function()
		appWatcher:stop()
	end)
	appWatcher:start()
end

local function toggleApp(app)
	if app:isFrontmost() then
		app:hide()
	else
		presentApp(app)
	end
end

local function launchApp(appName)
	if hs.application.launchOrFocus(appName) then
		return onAppLaunch(appName, presentApp)
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

	-- hs.application.get does fuzzy matching and may return helper processes
	-- like macOS Dock Extra (Ghostty.app) when the real app is not running.
	if app == nil or app:name() ~= appName then
		handlers.onNotLaunched(appName)
	else
		handlers.onOk(app)
	end
end

local weakFocusHandlers = {
	onOk = presentApp,
	onNotLaunched = alertNotLaunchedApp,
}

local focusAppHandlers = {
	onOk = presentApp,
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

return M
