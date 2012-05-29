-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

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

gold = 400
energy = 50
stardate = 48315.6

planetGravitationFieldRadius = 1.1
planetGraviationDamping = 1

-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "storyboard" module
local storyboard = require "storyboard"

-- load menu screen
storyboard.gotoScene( "level0" )