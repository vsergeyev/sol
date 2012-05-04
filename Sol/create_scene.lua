-----------------------------------------------------------------------------------------
--
-- create_scene.lua
--
-----------------------------------------------------------------------------------------

local movieclip = require "movieclip"
local mtouch = require( "mtouch" )

function createSun()
	sun = movieclip.newAnim({"i/sun1.png", "i/sun2.png", "i/sun3.png", "i/sun4.png", "i/sun5.png", "i/sun6.png"})
	sun.x, sun.y = 100, screenH - 100
	sun.r = 175
	sun.name = "sun"
	sun.nameType = "sun"
	sun:addEventListener('touch', selectPlanet)
	group:insert(sun)
	sun:setSpeed(0.2)
	-- sun:play()
end