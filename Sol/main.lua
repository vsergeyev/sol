-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

require "utils"

isPause = false
oneTouchBegan = false
touchesPinch = {}

screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

selectedObject = nil
selectOverlay = nil
groupSky = nil
group = nil
groupHud = nil
groupNotifications = nil
minimap = nil
groupX, groupY = 0, 0
sun = nil
ships = {}

gold = 100
energy = 50
stardate = 48315.6
levelNow = 1
portalDestroyed = false
isMusic = true

planetGravitationFieldRadius = 1.34
planetGraviationDamping = 1

gameTimers = {}
gameStat = {
	money = 0,
	ships = 0,
	killed = 0
}

-----------------------------------------------------------------------------------------

function purgeTimers()
	isPause = true
	-- remove all previously set timers
	for i=1, #gameTimers, 1 do
		-- print(gameTimers[i])
		timer.cancel(gameTimers[i])
	end
end


-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "storyboard" module
local storyboard = require "storyboard"

-- utils.showFps();

-- load menu screen
storyboard.gotoScene( "menu" )