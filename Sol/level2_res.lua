-- level2 resources

require "balance"

-----------------------------------------------------------------------------------------
function addShips()
	-- Portal to other System
	local t = "aliens/portal/"
	p = movieclip.newAnim({t.."1.png", t.."2.png", t.."3.png", t.."4.png", t.."5.png"})
	p:setSpeed(0.07)
	p:play()
	p.r = 50
	p.speed = 0.5
	p.x, p.y = -7200, 1700
	p.fullName = "Wormhole portal"
	p.name = "portal"
	p.nameType = "ship"
	p.enemy = false
	p.hp = 10000
	p.shield = 0
	p.res = {
		hp = 10000,
		shield = 0,
		speed = 0.5,
		attack = 0,
		w = 100,
		h = 100
	}
	p:addEventListener('touch', selectShip)
	physics.addBody(p, {radius=100, friction=0, filter=aliensCollisionFilter})
	p.isSensor = true
	p:addEventListener('collision', collisionShip)
	group:insert(p)

	-- Add fleet
	selectedObject = p
	buildShip({target=shipsData[1]}, true)
	-- buildShip({target=shipsData[1]}, true)
	-- buildShip({target=shipsData[2]}, true)
	-- buildShip({target=shipsData[2]}, true)
	buildShip({target=shipsData[6]}, true)
	buildShip({target=shipsData[6]}, true)
	buildShip({target=shipsData[7]}, true)
	-- for i=1, 3, 1 do
	-- 	buildShip({target=shipsData[5]}, true)
	-- end
end

-----------------------------------------------------------------------------------------
function addAliens()
	for i=1, 10, 1 do
		addAlienShip(group.neptune, 1)
	end
	for i=1, 4, 1 do
		addAlienShip(group.neptune, 4)
	end
	addAlienShip(group.neptune, 5)


	for i=1, 5, 1 do
		addAlienShip(group.earth, 1)
	end
	addAlienShip(group.earth, 4)

	for i=1, 10, 1 do
		addAlienShip(group.venus, 1)
	end
	addAlienShip(group.venus, 4)

	for i=1, 20, 1 do
		addAlienShip(group.mars, 1)
	end
	for i=1, 5, 1 do
		addAlienShip(group.mars, 4)
	end
	addAlienShip(group.mars, 5)
end

-----------------------------------------------------------------------------------------
function addPlanets2()
	-- Adds planets and moons
	group.planets = {}

	-- Venus
	local p = display.newImageRect("i/a/sirius0.png", 200, 200)
	p.x, p.y = screenW/1.5, screenH/1.5
	p.r = 100
	p.speed = 0.15
	p.x0, p.y0 = 100, screenH - 100
	p.orbit = 1200
	p.alphaR = 180
	p.fullName = "Sirius A0"
	p.name = "siriusa0"
	p.nameType = "planet"
	p.res = {
		colonized = false,
		population = 0,
		w = 200
	}
	group:insert(p)
	p:addEventListener('touch', selectPlanet)
	table.insert(group.planets, p)
	group.venus = p


	-- Earth
	local earth = display.newImageRect("i/a/titan.png", 250, 250)
	earth.x, earth.y = screenW/1.5, screenH/1.5
	earth.r = 125
	earth.speed = 0.1
	earth.x0, earth.y0 = 100, screenH - 100 -- 0, screenH
	earth.orbit = 2000
	earth.alphaR = 90
	earth.fullName = "Sirius B0"
	earth.name = "siriusb0"
	earth.nameType = "planet"
	earth.res = {
		colonized = false,
		population = 0,
		w = 250
	}
	group:insert(earth)
	group.earth = earth
	earth:addEventListener('touch', selectPlanet)
	table.insert(group.planets, earth)
	group.earth = earth

	-- Mars
	local p = display.newImageRect("i/uranus.png", 100, 100)
	p.x, p.y = screenW/1.5, screenH/1.5
	p.r = 50
	p.speed = 0.1
	p.x0, p.y0 = 100, screenH - 100
	p.orbit = 4000
	p.alphaR = 120
	p.fullName = "Sirius B1"
	p.name = "siriusb1"
	p.nameType = "planet"
	p.res = {
		colonized = false,
		population = 0,
		w = 100
	}
	group:insert(p)
	p:addEventListener('touch', selectPlanet)
	table.insert(group.planets, p)
	group.mars = p

	-- Neptune
	local p = display.newImageRect("i/a/sirius1.png", 300, 300)
	p.x, p.y = screenW/1.5, screenH/1.5
	p.r = 150
	p.speed = 0.01
	p.x0, p.y0 = 100, screenH - 100
	p.orbit = 7500
	p.alphaR = 180
	p.fullName = "Sirius B2"
	p.name = "siriusb2"
	p.nameType = "planet"
	p.enemy = true
	p.res = {
		colonized = false,
		population = 0,
		w = 300
	}
	group:insert(p)
	p:addEventListener('touch', selectPlanet)
	table.insert(group.planets, p)
	group.neptune = p

	-- Add gravitation fields for every planet
	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if g.nameType == "planet" then
			local gr = display.newImageRect("i/atmosphere.png", 2*g.r*planetGravitationFieldRadius, 2*g.r*planetGravitationFieldRadius)
			gr.x, gr.y = g.x, g.y+4
			-- local gr = display.newCircle(g.x, g.y, g.r*planetGravitationFieldRadius)
			-- local gr = display.newImageRect("i/shield.png", 2*g.r*planetGravitationFieldRadius, 2*g.r*planetGravitationFieldRadius)
			gr.name = "planet_field"
			gr.alpha = 0.5
			group:insert(gr)
			-- physics.addBody(gr, {friction=planetGraviationDamping, radius=planetGravitationFieldRadius})
			physics.addBody(gr, {radius=g.r*planetGravitationFieldRadius})
			gr.isSensor = true
			gr.planet = g
			g.field = gr
		end
	end

	asteroidsData = {
		{
			speed = 5,
			orbit = 800,
			alphaR = 90,
			fullName = "Asteroid K23L2"
		},
		{
			speed = 7,
			orbit = 2600,
			alphaR = 60,
			fullName = "Asteroid K23L3"
		},
		{
			speed = 8,
			orbit = 3200,
			alphaR = 150,
			fullName = "Asteroid K23L4"
		},
		{
			speed = 10,
			orbit = 4000,
			alphaR = 30,
			fullName = "Asteroid K23L1"
		},
	}

	for i=1, #asteroidsData, 1 do
		local d = asteroidsData[i]
		local a = display.newImageRect("i/asteroid.png", 50, 50)
		a.x, a.y = 1000, 500
		a.r = 50
		a.res = {
			w = 50
		}
		a.speed = d.speed
		a.x0, a.y0 = 100, screenH - 100
		a.orbit = d.orbit
		a.alphaR = d.alphaR
		a.fullName = d.fullName
		a.name = "asteroid"
		a.nameType = "asteroid"
		group:insert(a)
		a:addEventListener('touch', selectPlanet)
		physics.addBody(a, {radius=a.r})
		a.isSensor = true
		table.insert(group.planets, a)
	end
end