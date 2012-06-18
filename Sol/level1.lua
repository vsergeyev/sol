-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

--system.activate("multitouch")
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
require "create_scene"
require "hud"
require "minimap_ui"
require "economy"
require "fleet_control"
require "aliens"
require "ai"
require "notifications"
require "dialogs"

gold = 500
levelNow = nil
local skirmishLevel = 1
local skirmishDelay = 60000 -- 60000
local soundAlert = audio.loadStream("sounds/alert.m4a")

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

function winCondition( e )
	if portalDestroyed then
		showSurvivalDlg( e, "Victory!", true )
	end
end

function skirmishBattle( e )
	showBaloon("ALERT! ALERT! ALERT!\n\nFleet #"..skirmishLevel.." incoming")
	if isMusic then
		audio.play(soundAlert)
	end
	
	if skirmishLevel == 1 then
		for i=1, 5, 1 do
			addAlienShip(group.earth, 1)
		end
	elseif skirmishLevel < 6 then
		local count = 5 * skirmishLevel
		for i=1, count, 1 do
			addAlienShip(group.earth, 1)
		end
	elseif skirmishLevel < 10 then
		local count = 3 * skirmishLevel
		for i=1, count, 1 do
			addAlienShip(nil, 1)
		end
		for i=1, skirmishLevel, 1 do
			addAlienShip(nil, 2)
		end
	else
		for i=1, 20, 1 do
			addAlienShip(nil, 1)
		end
		for i=1, 5, 1 do
			addAlienShip(nil, 2)
		end

		addAlienShip(group.earth, 4)
	end

	skirmishLevel = skirmishLevel + 1
end

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

	local sky = display.newImageRect("bg/bg3.png", 1700, 1200)
	sky:setReferencePoint( display.CenterReferencePoint )
	sky.x, sky.y = screenW/2, screenH/2
	sky.alpha = 0.8
	groupSky:insert(sky)
	sky:addEventListener('touch', moveBg)
	
	local sky = display.newImageRect("bg/bg22.png", 1944, 1458) -- 1280, 852)	
	sky:setReferencePoint( display.CenterReferencePoint )
	sky.x, sky.y = screenW/2, screenH/2
	sky.alpha = 1
	groupSky:insert(sky)
	groupSky.sky = sky

	createSun()
	addPlanets()
	addHud()
	refreshMinimap()

	local pinch_overlay = display.newRect(0, 0, screenW, screenH)
	pinch_overlay:setFillColor( 0 )
	pinch_overlay.alpha = 0.01
	groupPinch:insert(pinch_overlay)

	mtouch.setZoomObject( pinch_overlay )
	mtouch.setOnZoomIn( OnZoomIn  ) 
	mtouch.setOnZoomOut( OnZoomOut  )

	-- Test planets positions with smaller zoom
	-- group.xScale = 0.5
	-- group.yScale = 0.5

	-- Timers
	table.insert(gameTimers, timer.performWithDelay(1000, animatePlanets, 0 ))
	table.insert(gameTimers, timer.performWithDelay(100, moveAutopilot, 0 ))
	table.insert(gameTimers, timer.performWithDelay(4000, moveFighters, 0 ))
	table.insert(gameTimers, timer.performWithDelay(6000, hightlightSun, 0 ))
	table.insert(gameTimers, timer.performWithDelay(200, refreshMinimap, 1 ))
	table.insert(gameTimers, timer.performWithDelay(3000, refreshMinimap, 0 ))
	-- table.insert(gameTimers, timer.performWithDelay(20000, calcIncome, 0 ))
	-- timer.performWithDelay(10000, stardateGo, 0 )
	table.insert(gameTimers, timer.performWithDelay(5000, targetShips, 0 ))
	table.insert(gameTimers, timer.performWithDelay(1000, repairCarrier, 0 ))
	table.insert(gameTimers, timer.performWithDelay(2000, winCondition, 0 ))

	if isMusic then
		local soundTheme = audio.loadStream("sounds/level1.m4a")
		table.insert(gameTimers, timer.performWithDelay(2000, function (e)
			audio.play(soundTheme)
		end, 0 ))
	end

	math.randomseed( os.time() )
	-- timer.performWithDelay(500, aiTurn, 0 )

	table.insert(gameTimers, timer.performWithDelay(100, movePlanets, 0 ))
	-- movePlanets()
	addAlienStations()

	-- Portal to other System
	local t = "aliens/portal/"
	p = movieclip.newAnim({t.."1.png", t.."2.png", t.."3.png", t.."4.png", t.."5.png"})
	p:setSpeed(0.2)
	p:play()
	p.r = 50
	p.speed = 0.5
	p.x, p.y = 7200, -1700
	p.fullName = "Wormhole portal"
	p.name = "portal"
	p.nameType = "ship"
	p.enemy = true
	p.hp = 10000
	p.shield = 0
	p.res = {
		hp = 10000,
		shield = 0,
		speed = 0.5,
		attack = 0,
	}
	p:addEventListener('touch', selectShip)
	physics.addBody(p, {radius=100, friction=0, filter=aliensCollisionFilter})
	p.isSensor = true
	p:addEventListener('collision', collisionShip)
	group:insert(p)

	table.insert(gameTimers, timer.performWithDelay(skirmishDelay, skirmishBattle, 0 ))

	-- Frame handlers
	Runtime:addEventListener( "enterFrame", frameHandler )

	-- Position camera on Earth
	group.x = -1350
	group.y = 250
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	physics.start()

	showInfo(selectedObject)
	showSurvivalDlg( event, "Survive in the waves of enemies.\n\nNext wave will arrive in 60 sec.\n\nTo win find Wormhole portal and destroy it.\n\nGood luck, Captain!" )
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