-----------------------------------------------------------------------------------------
--
-- game_ui.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require "storyboard"
require "dialogs"

local Particles = require("lib_particle_candy")

-----------------------------------------------------------------------------------------
function gamePause(e)
	-- Pause / Resume
	touchesPinch[ e.id ]  = nil

	if e.phase == "ended" then
		isPause = not isPause
		if isPause then
			physics.pause()
			Particles.Freeze()
			showPauseDlg()
		else
			Particles.WakeUp()
			physics.start()
		end
	end

	return true
end

-----------------------------------------------------------------------------------------
function gameMenu(e)
	touchesPinch[ e.id ]  = nil

	if e.phase == "ended" then
		purgeTimers()
		
		Particles.ClearParticles()
		while (#Particles.EmitterIndex) > 0 do Particles.DeleteEmitter(Particles.EmitterIndex[1]) end

		storyboard.gotoScene( "menu", "fade", 500 )
		-- gamePause(e)

		-- show menu
	end

	return true
end

-----------------------------------------------------------------------------------------
function gameRestart(e)
	touchesPinch[ e.id ]  = nil

	if e.phase == "ended" then
		purgeTimers()
		Particles.CleanUp()
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