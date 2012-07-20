-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

require "events"

local title = nil

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
	local bg = display.newImage("bg/bg2.png")
	group:insert(bg)
	local sky = display.newImageRect("ui/menu.png", 1024, 768)
	sky.x, sky.y = screenW/2, screenH/2
	group:insert(sky)

	-- Moon
	local moon = display.newImageRect("i/moon.png", 80, 80)
	moon.x, moon.y = screenW/2+1000, screenH
	moon.nameType = "planet"
	moon.x0, moon.y0 = screenW/2, screenH
	moon.orbit = 1000
	moon.alphaR = 90
	moon.speed = 10
	group:insert(moon)

	title = display.newImageRect("ui/menu_text.png", 1024, 768)
	title.x, title.y = screenW/2, screenH/2
	title.alpha = 0
	group:insert(title)
	
	local btnsX, btnsY = 100, screenH-300
	-- Buttons
	local cButton = addButton("Campaign", btnsX, btnsY, function (e)
		purgeTimers()
		isPause = false
		storyboard.removeScene( "mission1" )
		storyboard.gotoScene( "mission1", "fade", 500 )
	end)

	local sButton = addButton("Survival", btnsX, btnsY + 80, function (e)
		purgeTimers()
		isPause = false
		storyboard.removeScene( "level1" )
		storyboard.gotoScene( "level1", "fade", 500 )
	end)

	local ssButton = addButton("Assault", btnsX, btnsY + 160, function (e)
		purgeTimers()
		isPause = false
		storyboard.removeScene( "level2" )
		storyboard.gotoScene( "level2", "fade", 500 )
	end)

	local aButton = addButton("Credits", btnsX, btnsY + 240, function (e)
		purgeTimers()
		isPause = false
		storyboard.removeScene( "about" )
		storyboard.gotoScene( "about", "fade", 500 )
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
	group = self.view
	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	transition.to(title, {delay=500, time=1000, alpha=1})
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