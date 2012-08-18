-----------------------------------------------------------------------------------------
--
-- campaign.lua
--
-----------------------------------------------------------------------------------------

local mtouch = require( "mtouch" )
require "events"
require "planets"
require "create_scene"
require "hud"
require "minimap_ui"
require "economy"
require "fleet_control"
require "aliens"
require "ai"
require "levels_control"

local loose_condition_timer = nil

-----------------------------------------------------------------------------------------
function looseCondition( e )
	if isPause then return end

	-- Lost condition
	local not_lost = false
	for i = 1, #group.planets, 1 do
		local g = group.planets[i]
		if g.res and g.res.colonized then
			not_lost = true
			break
		end
	end
	if not not_lost then
		timer.cancel(loose_condition_timer)
		showSurvivalDlg( e, "You lost!", true )
	end
	return true
end

-----------------------------------------------------------------------------------------
function createLevel(view)
	local group0 = view
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

	local sky = display.newImageRect("bg/sun_nasa.png", 2048, 1351) --1700, 1200)
	sky:setReferencePoint( display.CenterReferencePoint )
	sky.x, sky.y = screenW/2, screenH/2
	sky.alpha = 1
	groupSky:insert(sky)
	groupSky.shine = sky
	
	local sky2 = display.newImageRect("bg/bg22.png", 1944, 1458) -- 1280, 852)	
	sky2:setReferencePoint( display.CenterReferencePoint )
	sky2.x, sky2.y = screenW/2, screenH/2
	sky2.alpha = 0.8 -- 0.1
	groupSky:insert(sky2)
	groupSky.sky = sky2
	table.insert(gameTimers, timer.performWithDelay(60, function (e)
		groupSky.sky.rotation = groupSky.sky.rotation + 0.1
	end, 0 ))

	--createSun()
	addPlanets()
	addHud()
	refreshMinimap()

	mtouch.setZoomObject( sky )
	mtouch.setOnZoomIn( OnZoomIn  ) 
	mtouch.setOnZoomOut( OnZoomOut  )

	-- Timers
	table.insert(gameTimers, timer.performWithDelay(300, moveAutopilot, 0 ))
	-- table.insert(gameTimers, timer.performWithDelay(6000, hightlightSun, 0 ))
	table.insert(gameTimers, timer.performWithDelay(3000, refreshMinimap, 0 ))
	table.insert(gameTimers, timer.performWithDelay(10000, populationGrow, 0 ))
	table.insert(gameTimers, timer.performWithDelay(5000, targetShips, 0 ))
	table.insert(gameTimers, timer.performWithDelay(1000, repairCarrier, 0 ))

	if isMusic then
		local soundTheme = audio.loadStream("sounds/level1.m4a")
		table.insert(gameTimers, timer.performWithDelay(2000, function (e)
			audio.play(soundTheme)
		end, 0 ))
	end

	math.randomseed( os.time() )
	table.insert(gameTimers, timer.performWithDelay(100, movePlanets, 0 ))

	-- Frame handlers
	Runtime:addEventListener( "enterFrame", frameHandler )

	return group
end

-----------------------------------------------------------------------------------------
function enterLevel()
	startLevel(levelNow)
	-- check victory or loose in level
	table.insert(gameTimers, timer.performWithDelay(1000, levelCondition, 0 ))
	loose_condition_timer = timer.performWithDelay(2000, looseCondition, 0 )
	table.insert(gameTimers, loose_condition_timer)

	showInfo(selectedObject)
end