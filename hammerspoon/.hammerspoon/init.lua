local spaces = require("hs.spaces")

-- Switch alacritty
hs.hotkey.bind("§", "§", function()
	local APP_NAME = "Alacritty"

	local function watchForAlacrittyLaunch()
		local appWatcher = nil

		appWatcher = hs.application.watcher.new(function(name, event, app)
			if event == hs.application.watcher.launched and name == APP_NAME then
				app:hide()
				visualizeApp(app) -- Where app = alacritty
				appWatcher:stop()
			end
		end)

		appWatcher:start()
	end

	local function setWinFrame(win)
		local scrFrame = hs.screen.mainScreen():fullFrame()

		local winFrame = win:frame()
		winFrame.w = scrFrame.w
		winFrame.y = scrFrame.y
		winFrame.x = scrFrame.x
		win:setFrame(winFrame, 0)
	end

	local function getMainWindow(alacritty)
		local win = nil

		while win == nil do
			win = alacritty:mainWindow()
		end

		return win
	end

	local function visualizeApp(app)
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

	local alacritty = hs.application.get(APP_NAME)

	if alacritty ~= nil and alacritty:isFrontmost() then
		alacritty:hide()
		return
	end

	if alacritty == nil and hs.application.launchOrFocus(APP_NAME) then
		watchForAlacrittyLaunch()
	end

	if alacritty ~= nil then
		visualizeApp(alacritty)
	end
end)
