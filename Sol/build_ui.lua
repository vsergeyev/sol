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
	b.res = {
		hp = 50,
		speed = 1,
		attack = 0,
		cost = 100,
		e = 10
	}
	b:addEventListener('touch', hudBuildShip)
	g:insert(b)

	local b = display.newImageRect("ui/build/fighters.png", 70, 70)
	b:setReferencePoint(display.TopLeftReferencePoint)
	b.x, b.y = 80, 0
	b.ship = "fighters"
	b.res = {
		hp = 200,
		speed = 2,
		attack = 10,
		cost = 200,
		e = 20
	}
	b:addEventListener('touch', hudBuildShip)
	g:insert(b)
	
	local b = display.newImageRect("ui/build/cruiser.png", 70, 70)
	b:setReferencePoint(display.TopLeftReferencePoint)
	b.x, b.y = 160, 0
	b.ship = "cruiser"
	b.res = {
		hp = 500,
		speed = 1,
		attack = 20,
		cost = 500,
		e = 50
	}
	b:addEventListener('touch', hudBuildShip)
	g:insert(b)
end
