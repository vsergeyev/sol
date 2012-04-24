-----------------------------------------------------------------------------------------
--
-- build_ui.lua
--
-----------------------------------------------------------------------------------------

require "build_control"


-----------------------------------------------------------------------------------------
function addBuildButtons(g)
	-- Build ships buttons
	local b = display.newImageRect("ui/build/explorer.png", 70, 70)
	b:setReferencePoint(display.TopLeftReferencePoint)
	b.x, b.y = 0, 0
	b.fullName = "Colonization ship"
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
	b.fullName = "Fighters squadron"
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
	b.fullName = "Battlecruiser"
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
	
	-- Tech buttons
	local b = display.newImageRect("ui/build/tech.png", 70, 70)
	b:setReferencePoint(display.TopLeftReferencePoint)
	b.x, b.y = 0, 80
	b.tech = "tech"
	b.res = {
		cost = 100,
		e = 10
	}
	b:addEventListener('touch', buildTech)
	g:insert(b)
	
	local b = display.newImageRect("ui/build/energy.png", 70, 70)
	b:setReferencePoint(display.TopLeftReferencePoint)
	b.x, b.y = 80, 80
	b.tech = "energy"
	b.res = {
		cost = 100,
		e = 10
	}
	b:addEventListener('touch', buildTech)
	g:insert(b)
	
	local b = display.newImageRect("ui/build/defence.png", 70, 70)
	b:setReferencePoint(display.TopLeftReferencePoint)
	b.x, b.y = 160, 80
	b.tech = "defence"
	b.res = {
		cost = 100,
		e = 10
	}
	b:addEventListener('touch', buildTech)
	g:insert(b)
end
