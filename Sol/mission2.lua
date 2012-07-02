-----------------------------------------------------------------------------------------
--
-- mission2.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

require "campaign"

local physics = require "physics"
physics.start(); physics.pause()
physics.setGravity(0, 0)

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	gold = 100
	levelNow = 2
	gameStat = {
		money = 0,
		ships = 0,
		killed = 0
	}

	local group = createLevel(self.view)
	-- Position camera on Earth
	group.x = -1700
	group.y = 250

	table.insert(gameTimers, timer.performWithDelay(500, addAlienStations, 1 ))
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	physics.start()
	enterLevel()
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	physics.stop()
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
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