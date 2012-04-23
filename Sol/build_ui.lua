-----------------------------------------------------------------------------------------
--
-- build_ui.lua
--
-----------------------------------------------------------------------------------------

function addBuildButtons(g)
	-- Build buttons
	local b = display.newImageRect("ui/build/explorer.png", 70, 70)
	b:setReferencePoint(display.TopLeftReferencePoint)
	b.x, b.y = 0, 0
	b.ship = "explorer"
	b:addEventListener('touch', hudBuildShip)
	g:insert(b)

	local b = display.newImageRect("ui/build/fighters.png", 70, 70)
	b:setReferencePoint(display.TopLeftReferencePoint)
	b.x, b.y = 80, 0
	b.ship = "fighters"
	b:addEventListener('touch', hudBuildShip)
	g:insert(b)
	
	local b = display.newImageRect("ui/build/cruiser.png", 70, 70)
	b:setReferencePoint(display.TopLeftReferencePoint)
	b.x, b.y = 160, 0
	b.ship = "cruiser"
	b:addEventListener('touch', hudBuildShip)
	g:insert(b)
end
