-----------------------------------------------------------------------------------------
--
-- aliens.lua
--
-----------------------------------------------------------------------------------------

require "notifications"

local aliensCollisionFilter = { groupIndex = -2 }

-----------------------------------------------------------------------------------------
function addAlienShip()
	-- add alien warship
	local ship = "cruiser"
	local planet = nil
	for i = 1, group.numChildren, 1 do
		planet = group[i]
		if planet.name == "neptune" then
			break
		end
	end

	local x = planet.x - 250 + math.random(500)
	local y = planet.y - 250 + math.random(500)

	local ship = display.newImageRect("aliens/"..ship..".png", 100, 100)
	ship.x, ship.y = x, y
	ship.enemy = true
	ship.targetPlanet = group.earth
	ship.targetReached = false
	ship.r = 75
	ship.orbit = 3 + math.random(3)
	ship.fullName = "Aliens battleship"
	ship.name = "aliens"
	ship.res = {
		hp = 80,
		speed = 1,
		attack = 1,
	}
	ship.nameType = "ship"
	physics.addBody(ship, {radius=50, friction=0, filter=aliensCollisionFilter})
	group:insert(ship)
	ship:addEventListener('touch', selectShip)
	ship:addEventListener('collision', collisionShip)

	showBaloon("Alien ship detected")
end
