local spaces = require("hs.spaces")

-- Switch alacritty
hs.hotkey.bind("§", "§", function()
	local APP_NAME = "Alacritty"

	local function watchForAlacrittyLaunch(mainScreen, spaceId)
		local appWatcher = nil

		appWatcher = hs.application.watcher.new(function(name, event, app)
			if event == hs.application.watcher.launched and name == APP_NAME then
				app:hide()
				moveWindow(app, mainScreen)
				appWatcher:stop()
			end
		end)

		appWatcher:start()
	end

	local function setWinFrame(mainScreen, win)
		local winFrame = win:frame()
		local scrFrame = mainScreen:fullFrame()
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

	local function moveWindow(alacritty, mainScreen)
		local spaceId = spaces.activeSpaceOnScreen()
		local win = getMainWindow(alacritty)

		local fullScreen = not win:isStandard()

		if fullScreen then
			hs.eventtap.keyStroke("cmd", "return", 0, alacritty)
		end

		setWinFrame(mainScreen, win)

		spaces.moveWindowToSpace(win, spaceId)
		spaces.spaceDisplay(spaceId)

		if fullScreen then
			hs.eventtap.keyStroke("cmd", "return", 0, alacritty)
		end

		win:focus()
	end

	local alacritty = hs.application.get(APP_NAME)

	if alacritty ~= nil and alacritty:isFrontmost() then
		alacritty:hide()
		return
	end

	local mainScreen = hs.screen.mainScreen()

	if alacritty == nil and hs.application.launchOrFocus(APP_NAME) then
		watchForAlacrittyLaunch(mainScreen)
	end

	if alacritty ~= nil then
		moveWindow(alacritty, mainScreen)
	end
end)