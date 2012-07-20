-----------------------------------------------------------------------------------------
--
-- level2.lua
--
-----------------------------------------------------------------------------------------

local mtouch = require( "mtouch" )

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local movieclip = require "movieclip"

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

-- physics.setDrawMode('hybrid')
physics.setGravity(0, 0)

--------------------------------------------

require "events"
require "planets"
require "hud"
require "minimap_ui"
require "economy"
require "fleet_control"
require "aliens"
require "ai"
require "notifications"
require "dialogs"
require "level2_res"

gold = 590
levelNow = nil
local win_condition_timer = nil

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

function winCondition( e )
	if isPause then return end

	local win = true
	local not_lost = false
	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if g.nameType == "ship" and g.enemy then
			win = false
		elseif g.nameType == "ship" and not g.enemy then
			not_lost = true
		end
	end

	-- Victory condition
	if win then
		timer.cancel(win_condition_timer)
		showSurvivalVictoryDlg(e)
		return true
	end

	if not not_lost then
		timer.cancel(win_condition_timer)
		showSurvivalDlg( e, "You lost!", true )
	end
	return true
end

-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group0 = self.view
	groupSky = display.newGroup()
	group = display.newGroup() -- self.view
	groupHud = display.newGroup()
	groupNotifications = display.newGroup()
	groupPinch = display.newGroup()

	group0:insert(groupSky)
	group0:insert(group)
	group0:insert(groupHud)
	group0:insert(groupNotifications)
	group0:insert(groupPinch)

	local sky = display.newImageRect("bg/sol_nasa.png", 2000, 1125) --1700, 1200)
	sky:setReferencePoint( display.CenterReferencePoint )
	sky.x, sky.y = screenW/2, screenH/2
	sky.alpha = 1
	groupSky:insert(sky)
	groupSky.shine = sky
	-- sky:addEventListener('touch', moveBg)
	
	addPlanets2()
	addHud()
	refreshMinimap()

	mtouch.setZoomObject( sky ) --pinch_overlay )
	mtouch.setOnZoomIn( OnZoomIn  ) 
	mtouch.setOnZoomOut( OnZoomOut  )

	-- Timers
	table.insert(gameTimers, timer.performWithDelay(300, moveAutopilot, 0 ))
	table.insert(gameTimers, timer.performWithDelay(3000, refreshMinimap, 0 ))
	table.insert(gameTimers, timer.performWithDelay(5000, targetShips, 0 ))
	table.insert(gameTimers, timer.performWithDelay(1000, repairCarrier, 0 ))
	-- win_condition_timer = timer.performWithDelay(2000, winCondition, 0 )
	-- table.insert(gameTimers, win_condition_timer)

	if isMusic then
		local soundTheme = audio.loadStream("sounds/level1.m4a")
		table.insert(gameTimers, timer.performWithDelay(2000, function (e)
			audio.play(soundTheme)
		end, 0 ))
	end

	math.randomseed( os.time() )
	-- timer.performWithDelay(500, aiTurn, 0 )

	table.insert(gameTimers, timer.performWithDelay(100, movePlanets, 0 ))
	table.insert(gameTimers, timer.performWithDelay(500, addAlienStations, 1 ))

	addShips()
	addAliens()

	-- Frame handlers
	Runtime:addEventListener( "enterFrame", frameHandler )

	-- Position camera on Portal
	group.x, group.y = 7200+screenW/2, -1700+screenH/2
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	for i = 1, #planetsData, 1 do
		groupHud.planets.buttons[i][1].alpha = 0
		groupHud.planets.buttons[i][2].alpha = 0
		groupHud.fleet.buttons[i][1].alpha = 0
		groupHud.fleet.buttons[i][2].alpha = 0
	end

	physics.start()

	showInfo(selectedObject)
	showSurvivalDlg( event, [[Eliminate all alien presence in this sector

Good luck, Captain!]], false, "Assault mode")
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	physics.stop()
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene