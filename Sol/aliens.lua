-----------------------------------------------------------------------------------------
--
-- aliens.lua
--
-----------------------------------------------------------------------------------------

require "notifications"
require "balance"

local movieclip = require "movieclip"

local aliensCollisionFilter = { groupIndex = -2 }

-----------------------------------------------------------------------------------------
function addAlienShip(target, shipKind)
	-- adds alien warship

	local shipData = nil
	if shipKind then
		shipData = aliensData[shipKind]
	else
		shipData = aliensData[math.random(4)]
	end

	local planet = group.neptune

	local x = planet.x - 250 + math.random(500)
	local y = planet.y - 250 + math.random(500)
	local ship = nil

	if shipData.name == "fighter" then
		local p = "aliens/"..shipData.name.."/"
		ship = movieclip.newAnim({p.."1.png", p.."3.png", p.."4.png"})
		ship:setSpeed(0.15)
		ship:play()
	elseif shipData.name == "frigate" then
		local p = "aliens/"..shipData.name.."/"
		ship = movieclip.newAnim({p.."1.png", p.."2.png", p.."3.png", p.."4.png"})
		ship:setSpeed(0.15)
		ship:play()
	elseif shipData.name == "bs" then
		local p = "aliens/bs/"
		ship = movieclip.newAnim({p.."1.png", p.."1.png", p.."1.png", p.."1.png", p.."1.png", p.."2.png", p.."3.png", p.."4.png", p.."3.png", p.."2.png"})
		ship:setSpeed(0.12)
		ship:play()
	else
		ship = display.newImageRect("aliens/"..shipData.name..".png", shipData.res.w, shipData.res.h)
	end
	ship.x, ship.y = x, y
	ship.enemy = true
	ship.enemies = {}
	ship.r = 75
	ship.sensors = 50 -- how long it see Terran ships
	ship.orbit = 1.5 + math.random(30) / 10
	ship.alphaR = 90
	ship.fullName = shipData.fullName
	ship.name = shipData.ship
	ship.name2 = shipData.name
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
	if target and target.fullName then
		ship.targetPlanet = target
	else	
		ship.targetPlanet =  group.planets[math.random(#group.planets)] --group.earth
	end
	-- print(ship.targetPlanet.fullName)
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
	shipData = aliensData[3]

	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if (g.nameType == "planet" and not g.res.colonized) and (g.name ~= "moon") then
			-- local ship = display.newImageRect("aliens/bs.png", shipData.res.w, shipData.res.h)
			local p = "aliens/bs/"
			ship = movieclip.newAnim({p.."1.png", p.."1.png", p.."1.png", p.."1.png", p.."1.png", p.."2.png", p.."3.png", p.."4.png", p.."3.png", p.."2.png"})
			ship:setSpeed(0.12)
			ship:play()

			ship.x, ship.y = g.x, g.y
			ship.enemy = true
			ship.enemies = {}
			ship.targetPlanet = g
			ship.targetReached = false
			ship.r = 75
			ship.sensors = 300 -- how long it see Terran ships
			ship.orbit = 1 + math.random(3)
			ship.alphaR = 90
			ship.fullName = shipData.fullName
			ship.nameType = "ship"
			ship.name = shipData.ship
			ship.name2 = shipData.name
			ship.is_station = true
			ship.res = shipData.res
			ship.hp = ship.res.hp
			ship.shield = ship.res.shield
			
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