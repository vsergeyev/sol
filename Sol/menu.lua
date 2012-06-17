-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

require "events"

--------------------------------------------

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	isPause = true

	-- local group = self.view
	group = self.view --display.newGroup()

	-- display a background image
	local sky = display.newImageRect("bg/bg3.png", 1700, 1200)
	sky:setReferencePoint( display.CenterReferencePoint )
	sky.x, sky.y = screenW/2, screenH/2
	sky.alpha = 0.8
	group:insert(sky)
	
	-- Earth
	local earth = display.newImageRect("i/earth.png", 300, 300)
	earth.x, earth.y = 200, screenH-200
	group:insert(earth)
	
	-- Moon
	local moon = display.newImageRect("i/moon.png", 80, 80)
	moon.x, moon.y = screenW-100, 200
	moon.nameType = "planet"
	moon.x0, moon.y0 = earth.x, earth.y
	moon.orbit = 800
	moon.alphaR = 90
	moon.speed = 10
	group:insert(moon)
	
	-- Buttons
	local cButton = display.newText("|| Tutorial", screenW-300, screenH-320, 300, 60, native.systemFont, 36)
	cButton:setTextColor(0, 200, 100)
	group:insert(cButton)
	cButton:addEventListener('touch', function (e)
		media.playVideo( "tutorial/movie.mov", false )
		return true
	end)

	local cButton = display.newText("|| Campaign", screenW-300, screenH-240, 300, 60, native.systemFont, 36)
	cButton:setTextColor(0, 200, 100)
	group:insert(cButton)
	cButton:addEventListener('touch', function (e)
		purgeTimers()
		isPause = false
		storyboard.removeScene( "level0" )
		storyboard.gotoScene( "level0", "fade", 500 )
		return true
	end)

	local sButton = display.newText("|| Survival", screenW-300, screenH-160, 300, 60, native.systemFont, 36)
	sButton:setTextColor(0, 200, 100)
	group:insert(sButton)
	sButton:addEventListener('touch', function (e)
		purgeTimers()
		isPause = false
		storyboard.removeScene( "level1" )
		storyboard.gotoScene( "level1", "fade", 500 )
		return true
	end)

	local aButton = display.newText("|| Credits", screenW-300, screenH-80, 300, 60, native.systemFont, 36)
	aButton:setTextColor(0, 200, 100)
	group:insert(aButton)
	aButton:addEventListener('touch', function (e)
		purgeTimers()
		isPause = false
		storyboard.removeScene( "about" )
		storyboard.gotoScene( "about", "fade", 500 )
		return true
	end)

	-- Timers
	table.insert(gameTimers, timer.performWithDelay(100, function (e)
		local g = moon
		g.alphaR = g.alphaR + 0.0002 * g.speed
		g.x = g.x0  + g.orbit * math.sin(g.alphaR)
		g.y = g.y0  + g.orbit/1.5 * math.cos(g.alphaR)
	end, 0 ))
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
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