-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

system.activate("multitouch")

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local movieclip = require "movieclip"

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

-- physics.setDrawMode('hybrid')
physics.setGravity(0, 0)

--------------------------------------------

-- forward declarations and other locals
screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

-- require "events"
-- require "players"

groupSky = nil
group = nil
groupX, groupY = 0, 0
selectOverlay = nil
sun = nil

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

function rotateSky( e )
	groupSky.rotation = groupSky.rotation - 0.05
end

function hightlightSun( e )
	local s = display.newCircle(sun.x, sun.y, sun.r)
	-- local s = display.newImageRect("i/sun2.png", 350, 350)
	-- s.x, s.y = sun.x, sun.y

	local function removeHightligth( e )
		s:removeSelf()
	end

	s:setFillColor(200, 200, 0)
	s.alpha = 0.01
	group:insert(s)
	transition.to(s, {time=2000, alpha=0.3})
	transition.to(s, {delay=2000, time=2000, alpha=0.01, onComplete=removeHightligth})
end

function movePlanets( e )
	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if g.nameType == "planet" then
			g.alphaR = g.alphaR + 0.001 * g.speed
			g.x = g.x0  + g.orbit * math.sin(g.alphaR)
			g.y = g.y0  + g.orbit * math.cos(g.alphaR)
			if g.overlay then
				g.overlay.x = g.x
				g.overlay.y = g.y
			end
		end
	end
end

function selectPlanet( e )
	local t = e.target

	if selectOverlay then
		selectOverlay:removeSelf()
	end
	
	selectOverlay = display.newCircle(t.x, t.y, t.r)
	selectOverlay.alpha = 0.2
	selectOverlay.strokeWidth = 5
	selectOverlay:setStrokeColor(255)
	group:insert(selectOverlay)
	t.overlay = selectOverlay
end

function moveBg( e )
	if e.phase == "began" then
		groupX, groupY = group.x, group.y
	elseif e.phase == "moved" then
		group.x = groupX + (e.x - e.xStart)
		group.y = groupY + (e.y - e.yStart)
	elseif e.phase == "ended" or e.phase == "cancelled" then
		groupX, groupY = 0, 0
	end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	groupSky = display.newGroup()

	group = display.newGroup() -- self.view

	local sky = display.newImageRect("i/sky.jpg", 1024, 768)
	sky:setReferencePoint( display.CenterReferencePoint )
	sky.x, sky.y = screenW/2, screenH/2
	groupSky:insert(sky)

	local g = graphics.newGradient(
	  { 0, 0, 0 },
	  { 50, 50, 50 },
	  "down" )

	local bg = display.newRect( -screenW, -screenH, 3*screenW, 3*screenH)
	bg:setFillColor( g )
	bg.alpha = 0.5
	group:insert(bg)
	bg:addEventListener('touch', moveBg)

	sun = movieclip.newAnim({"i/sun1.png", "i/sun2.png", "i/sun3.png", "i/sun4.png", "i/sun5.png", "i/sun6.png"})
	sun.x, sun.y = 100, screenH - 100
	sun.r = 175
	sun.name = "sun"
	sun:addEventListener('touch', selectPlanet)
	group:insert(sun)
	sun:setSpeed(0.2)
	-- sun:play()

	local earth = display.newImageRect("i/earth.png", 100, 100)
	earth.x, earth.y = screenW/1.5, screenH/1.5
	earth.r = 50
	earth.speed = 1
	earth.x0, earth.y0 = 0, screenH
	earth.orbit = screenW/1.5
	earth.alphaR = 90
	earth.name = "earth"
	earth.nameType = "planet"
	group:insert(earth)
	earth:addEventListener('touch', selectPlanet)


	local p = display.newImageRect("i/mercury.png", 60, 60)
	p.x, p.y = screenW/1.5, screenH/1.5
	p.r = 30
	p.speed = 2
	p.x0, p.y0 = 50, screenH - 50
	p.orbit = 300
	p.alphaR = 0
	p.name = "mercury"
	p.nameType = "planet"
	group:insert(p)
	p:addEventListener('touch', selectPlanet)

	-- Timers
	-- timer.performWithDelay(100, rotateSky, 0 )
	timer.performWithDelay(100, movePlanets, 0 )
	timer.performWithDelay(6000, hightlightSun, 0 )

	-- Frame handlers
	-- Runtime:addEventListener( "enterFrame", frameHandler )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	physics.start()
	
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