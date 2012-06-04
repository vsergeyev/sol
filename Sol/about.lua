-----------------------------------------------------------------------------------------
--
-- credits.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--------------------------------------------

local textAbout = nil

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
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

	textAbout = display.newText([[Sol Control


Programming:
Volodymyr Sergeyev

Design:
Vlad Stepaniuk

Q&A:
Nazar Leush
]], screenW - 400, screenH, 400, 600, native.systemFont, 36)
	textAbout:setTextColor(0, 200, 100)
	group:insert(textAbout)
	
	sky:addEventListener('touch', function (e)
		storyboard.gotoScene( "menu", "fade", 500 )
		return true
	end)

	-- Timers
	timer.performWithDelay(50, function (e)
		textAbout.y = textAbout.y -  2
	end, 0 )
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