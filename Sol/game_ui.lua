-----------------------------------------------------------------------------------------
--
-- game_ui.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require "storyboard"

-----------------------------------------------------------------------------------------
local function showPauseDlg(e)
	local p = display.newGroup()
	local dx, dy = 150, 150

	local dlg = display.newRoundedRect(100, 100, screenW-200, screenH-200, 10)
	dlg:setFillColor(0)
	dlg.alpha = 0.9
	p:insert(dlg)

	local ea = display.newImageRect("ui/alliance.png", 100, 101)
	ea.x, ea.y = screenW-200, dy + 50
	p:insert(ea)

	local infoTitle = display.newText("Game paused", dx + 20, dy + 20, 600, 40, native.systemFont, 24)
	infoTitle:setTextColor(0, 200, 100)
	p:insert(infoTitle)

	if levelNow then
		local infoText = display.newText(levelsData[levelNow].task, dx + 20, dy + 100, 600, 400, native.systemFont, 18)
		infoText:setTextColor(0, 200, 100)
		p:insert(infoText)
	end

	local menuButton = display.newText("|| Exit to menu", screenW-500, screenH-200, 200, 40, native.systemFont, 24)
	menuButton:setTextColor(0, 200, 100)
	p:insert(menuButton)
	menuButton:addEventListener('touch', function (e)
		if e.phase == 'ended' then
			p:removeSelf()
			gameMenu(e)
		end

		return true
	end)

	local closeButton = display.newText("|| Resume", screenW-310, screenH-200, 200, 40, native.systemFont, 24)
	closeButton:setTextColor(0, 200, 100)
	p:insert(closeButton)
	closeButton:addEventListener('touch', function (e)
		if e.phase == 'ended' then
			p:removeSelf()
			gamePause(e)
		end

		return true
	end)
end

-----------------------------------------------------------------------------------------
function gamePause(e)
	-- Pause / Resume
	if e.phase == "ended" then
		isPause = not isPause
		if isPause then
			physics.pause()
			showPauseDlg()
		else
			physics.start()
		end
	end

	return true
end

-----------------------------------------------------------------------------------------
function gameMenu(e)
	if e.phase == "ended" then
		purgeTimers()
		storyboard.gotoScene( "menu", "fade", 500 )
		-- gamePause(e)

		-- show menu
	end

	return true
end

-----------------------------------------------------------------------------------------
function gameRestart(e)
	if e.phase == "ended" then
		purgeTimers()
		storyboard.reloadScene()

		-- groupSky:removeSelf()
		-- group:removeSelf()
		-- groupHud:removeSelf()
		-- groupNotifications:removeSelf()
		-- groupPinch:removeSelf()

		-- storyboard.gotoScene( "restart" )
	end

	return true
end