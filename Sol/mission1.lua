-----------------------------------------------------------------------------------------
--
-- mission1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

require "campaign"

local physics = require "physics"
physics.start(); physics.pause()
physics.setGravity(0, 0)

local hint1, hint2 = nil, nil

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
	levelNow = 1
	gameStat = {
		money = 0,
		ships = 0,
		killed = 0
	}

	local group = createLevel(self.view)
	-- Position camera on Earth
	group.x = -1700
	group.y = 250
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	physics.start()
	showInfo(group.earth)
	
	hint1 = showHint("Build E.C.S. ship and target in to Moon", screenW-460, screenH-190)

	timer.performWithDelay(300, function (e)
		for i = 1, group.numChildren, 1 do
			if group[i].name == "explorer" then
				hint1.parent:remove(hint1)
				timer.cancel(e.source)

				-- 2nd hint
				timer.performWithDelay(200, function (e)
					if group.earth.moon.res.colonized then
						hint1 = showHint("Select Earth, build Minecrafter ship and target in to Moon to gather credits", screenW-460, screenH-190)
						timer.cancel(e.source)
					end
				end, 0 )

				break
			end
		end
		return true
	end, 0 )

	timer.performWithDelay(400, function (e)
		for i = 1, group.numChildren, 1 do
			if group[i].name == "trade" then
				hint1.parent:remove(hint1)
				timer.cancel(e.source)
				break
			end
		end
		return true
	end, 0 )

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