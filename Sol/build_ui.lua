-----------------------------------------------------------------------------------------
--
-- build_ui.lua
--
-----------------------------------------------------------------------------------------

function addBuildButtons(g)
	-- Build buttons
	local b = display.newImageRect("ui/build/scout.png", 70, 70)
	b:setReferencePoint(display.TopLeftReferencePoint)
	b.x, b.y = 0, 0
	b.ship = "scout"
	b:addEventListener('touch', hudBuildShip)
	g:insert(b)
	
	local b = display.newImageRect("ui/build/cruiser.png", 70, 70)
	b:setReferencePoint(display.TopLeftReferencePoint)
	b.x, b.y = 80, 0
	b.ship = "cruiser"
	b:addEventListener('touch', hudBuildShip)
	g:insert(b)
end
