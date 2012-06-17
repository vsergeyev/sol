-----------------------------------------------------------------------------------------
--
-- game_ui.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require "storyboard"
require "dialogs"

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