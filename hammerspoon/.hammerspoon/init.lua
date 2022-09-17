local spaces = require("hs.spaces")

-- Switch alacritty
hs.hotkey.bind("§", "§", function()
	local APP_NAME = "Alacritty"
	function moveWindow(alacritty, spaceId, mainScreen)
		-- move to main space
		local win = nil

		while win == nil do
			win = alacritty:mainWindow()
		end

		local fullScreen = not win:isStandard()
		if fullScreen then
			hs.eventtap.keyStroke("cmd", "return", 0, alacritty)
		end

		local winFrame = win:frame()
		local scrFrame = mainScreen:fullFrame()
		winFrame.w = scrFrame.w
		winFrame.y = scrFrame.y
		winFrame.x = scrFrame.x
		win:setFrame(winFrame, 0)
		spaces.gotoSpace(spaceId)

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

	local spaceId = spaces.activeSpaceOnScreen()
	local mainScreen = hs.screen.mainScreen()

	if alacritty == nil and hs.application.launchOrFocus(APP_NAME) then
		local appWatcher = nil
		appWatcher = hs.application.watcher.new(function(name, event, app)
			if event == hs.application.watcher.launched and name == APP_NAME then
				app:hide()
				moveWindow(app, spaceId, mainScreen)
				appWatcher:stop()
			end
		end)
		appWatcher:start()
	end

	if alacritty ~= nil then
		moveWindow(alacritty, spaceId, mainScreen)
	end
end)
