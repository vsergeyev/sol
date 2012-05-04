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

	local ship = display.newImageRect("aliens/"..ship..".png", 150, 53)
	ship.x, ship.y = x, y
	ship.enemy = true
	ship.enemies = {}
	ship.targetPlanet = group.earth
	ship.targetReached = false
	ship.r = 75
	ship.sensors = 300 -- how long it see Terran ships
	ship.orbit = 3 + math.random(3)
	ship.alphaR = 90
	ship.fullName = "Aliens battleship"
	ship.name = "aliens"
	ship.res = {
		hp = 80,
		speed = 1.5,
		attack = 1,
	}
	ship.hp = ship.res.hp
	ship.nameType = "ship"
	physics.addBody(ship, {radius=ship.sensors, friction=0, filter=aliensCollisionFilter})
	ship.isSensor = true
	group:insert(ship)
	ship:addEventListener('touch', selectShip)
	ship:addEventListener('collision', collisionShip)
	-- ship:addEventListener('postCollision', escapeShip)

	showBaloon("Alien ship detected")
end
