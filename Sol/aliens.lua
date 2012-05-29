-----------------------------------------------------------------------------------------
--
-- aliens.lua
--
-----------------------------------------------------------------------------------------

require "notifications"
require "balance"

local aliensCollisionFilter = { groupIndex = -2 }

-----------------------------------------------------------------------------------------
function addAlienShip()
	-- adds alien warship

	local ship = "cruiser"
	local shipData = aliensData[1]

	local planet = group.neptune

	local x = planet.x - 250 + math.random(500)
	local y = planet.y - 250 + math.random(500)

	local ship = display.newImageRect("aliens/"..shipData.name..".png", shipData.res.w, shipData.res.h)
	ship.x, ship.y = x, y
	ship.enemy = true
	ship.enemies = {}
	ship.r = 75
	ship.sensors = 300 -- how long it see Terran ships
	ship.orbit = 3 + math.random(3)
	ship.alphaR = 90
	ship.fullName = shipData.fullName
	ship.name = shipData.ship
	ship.res = shipData.res
	ship.hp = ship.res.hp
	ship.shield = ship.res.shield
	ship.nameType = "ship"
	physics.addBody(ship, {radius=ship.sensors, friction=0, filter=aliensCollisionFilter})
	ship.isSensor = true
	group:insert(ship)
	ship:addEventListener('touch', selectShip)
	ship:addEventListener('collision', collisionShip)
	-- ship:addEventListener('postCollision', escapeShip)

	-- by default send aliens to Earth
	ship.targetPlanet =  group.planets[math.random(#group.planets)] --group.earth
	ship.targetReached = false

	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if g.is_station and g.enemy and g.inBattle then
			-- aliens battle station under attack
			-- sending reinforcements
			ship.targetPlanet = g.planet
		end
	end

	-- showBaloon("Alien ship detected")
end

-----------------------------------------------------------------------------------------
function addAlienStations()
	-- adds alien battle stations to all planets except Earth

	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if g.nameType == "planet" and not g.res.colonized then
			local ship = display.newImageRect("aliens/station.png", 50, 50)
			ship.x, ship.y = 0, 0
			ship.enemy = true
			ship.enemies = {}
			ship.targetPlanet = g
			ship.targetReached = true
			ship.r = 75
			ship.sensors = 300 -- how long it see Terran ships
			ship.orbit = 1 + math.random(3)
			ship.alphaR = 90
			ship.fullName = "Aliens battle station"
			ship.name = "aliens"
			ship.is_station = true
			ship.res = {
				hp = 1000,
				shield = 500,
				attack = 2,
				speed = 0.01,
				w = 50,
				h = 50
			}
			ship.hp = ship.res.hp
			ship.shield = ship.res.shield
			ship.nameType = "ship"
			physics.addBody(ship, {radius=ship.sensors, friction=0, filter=aliensCollisionFilter})
			ship.isSensor = true
			ship.isFixedRotation = true
			group:insert(ship)
			ship:addEventListener('touch', selectShip)
			ship:addEventListener('collision', collisionShip)

			ship.planet = g
		end
	end
end