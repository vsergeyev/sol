-----------------------------------------------------------------------------------------
--
-- build_ui.lua
--
-----------------------------------------------------------------------------------------

function addBuildButtons(buildGroup)
	-- Build buttons
	local buildShip = display.newImageRect("ui/build/scout.png", 70, 70)
	buildShip:setReferencePoint(display.TopLeftReferencePoint)
	buildShip.x, buildShip.y = 0, 0
	buildShip.name = "button"
	buildShip.nameType = "build"
	buildShip.ship = "scout"
	buildShip:addEventListener('touch', hudBuildShip)
	buildGroup:insert(buildShip)
	
	local buildShip = display.newImageRect("ui/build/cruiser.png", 70, 70)
	buildShip:setReferencePoint(display.TopLeftReferencePoint)
	buildShip.x, buildShip.y = 80, 0
	buildShip.name = "button"
	buildShip.nameType = "build"
	buildShip.ship = "cruiser"
	buildShip:addEventListener('touch', hudBuildShip)
	buildGroup:insert(buildShip)
end