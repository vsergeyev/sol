-----------------------------------------------------------------------------------------
--
-- planets.lua
--
-----------------------------------------------------------------------------------------

local movieclip = require "movieclip"
require "badges"

function addPlanets()
	-- Adds planets and moons
	group.planets = {}

	-- Mercury
	local p = display.newImageRect("i/mercury.png", 120, 120)
	p.x, p.y = screenW/1.5, screenH/1.5
	p.r = 60
	p.speed = 0.2
	p.x0, p.y0 = 100, screenH - 100
	p.orbit = 600
	p.alphaR = 0
	p.fullName = "Mercury"
	p.name = "mercury"
	p.nameType = "planet"
	p.res = {
		supplies = 50,
		colonized = false,
		population = 0,
		techlevel = 0,
		defence = 0,
		generators = 0,
		w = 120
	}
	group:insert(p)
	p:addEventListener('touch', selectPlanet)
	table.insert(group.planets, p)


	-- Venus
	local p = display.newImageRect("i/venus.png", 160, 160)
	p.x, p.y = screenW/1.5, screenH/1.5
	p.r = 80
	p.speed = 0.15
	p.x0, p.y0 = 100, screenH - 100
	p.orbit = 1200
	p.alphaR = 180
	p.fullName = "Venus"
	p.name = "venus"
	p.nameType = "planet"
	p.res = {
		supplies = 100,
		colonized = false,
		population = 0,
		techlevel = 0,
		defence = 0,
		generators = 0,
		w = 160
	}
	group:insert(p)
	p:addEventListener('touch', selectPlanet)
	table.insert(group.planets, p)


	-- Earth
	local earth = display.newImageRect("i/earth.png", 300, 300)
	earth.x, earth.y = screenW/1.5, screenH/1.5
	earth.r = 150
	earth.speed = 0.1
	earth.x0, earth.y0 = 100, screenH - 100 -- 0, screenH
	earth.orbit = 2000
	earth.alphaR = 90
	earth.fullName = "Earth"
	earth.name = "earth"
	earth.nameType = "planet"
	earth.res = {
		colonized = true,
		population = 7 * 1000000000,
		techlevel = 1,
		defence = 1,
		generators = 1,
		at = stardate,
		w = 300
	}
	group:insert(earth)
	group.earth = earth
	earth:addEventListener('touch', selectPlanet)
	table.insert(group.planets, earth)
	addDefenceBadge(earth)
	addHumanBadge(earth)

	-- Moon
	local moon = display.newImageRect("i/moon.png", 80, 80)
	moon.x, moon.y = screenW/1.5, screenH/1.5
	moon.r = 40
	moon.speed = 1
	moon.x0, moon.y0 = earth.x, earth.y
	moon.orbit = 800
	moon.alphaR = 90
	moon.fullName = "Moon"
	moon.name = "moon"
	moon.nameType = "planet" -- moon" -- "planet"
	moon.res = {
		supplies = 0,
		colonized = false, -- true,
		population = 0, -- 30000,
		techlevel = 0,
		defence = 0,
		generators = 0,
		w = 80
	}
	group:insert(moon)
	moon:addEventListener('touch', selectPlanet)

	earth.moon = moon


	-- Mars
	local p = display.newImageRect("i/mars.png", 200, 200)
	p.x, p.y = screenW/1.5, screenH/1.5
	p.r = 100
	p.speed = 0.1
	p.x0, p.y0 = 100, screenH - 100
	p.orbit = 4000
	p.alphaR = 120
	p.fullName = "Mars"
	p.name = "mars"
	p.nameType = "planet"
	p.res = {
		supplies = 40,
		colonized = false,
		population = 0,
		techlevel = 0,
		defence = 0,
		generators = 0,
		w = 200
	}
	group:insert(p)
	p:addEventListener('touch', selectPlanet)
	table.insert(group.planets, p)


	-- Jupiter
	-- local p = display.newImageRect("i/jupiter.png", 200, 200)
	-- p.x, p.y = screenW/1.5, screenH/1.5
	-- p.r = 100
	-- p.speed = 0.1
	-- p.x0, p.y0 = 100, screenH - 100
	-- p.orbit = 5000
	-- p.alphaR = 200
	-- p.fullName = "Jupiter"
	-- p.name = "jupiter"
	-- p.nameType = "planet"
	-- p.res = {
	-- 	supplies = 300,
	-- 	colonized = false,
	-- 	population = 0,
	-- 	techlevel = 0,
	-- 	defence = 0,
	-- 	generators = 0
	-- }
	-- group:insert(p)
	-- p:addEventListener('touch', selectPlanet)
	-- table.insert(group.planets, p)


	-- -- Saturn
	-- local p = display.newImageRect("i/saturn.png", 200, 200)
	-- p.x, p.y = screenW/1.5, screenH/1.5
	-- p.r = 100
	-- p.speed = 0.1
	-- p.x0, p.y0 = 100, screenH - 100
	-- p.orbit = 6000
	-- p.alphaR = 100
	-- p.fullName = "Saturn"
	-- p.name = "saturn"
	-- p.nameType = "planet"
	-- p.res = {
	-- 	supplies = 100,
	-- 	colonized = false,
	-- 	population = 0,
	-- 	techlevel = 0,
	-- 	defence = 0,
	-- 	generators = 0
	-- }
	-- group:insert(p)
	-- p:addEventListener('touch', selectPlanet)
	-- table.insert(group.planets, p)


	-- -- Uranus
	-- local p = display.newImageRect("i/uranus.png", 100, 100)
	-- p.x, p.y = screenW/1.5, screenH/1.5
	-- p.r = 50
	-- p.speed = 0.2
	-- p.x0, p.y0 = 100, screenH - 100
	-- p.orbit = 7000
	-- p.alphaR = 0
	-- p.fullName = "Uranus"
	-- p.name = "uranus"
	-- p.nameType = "planet"
	-- p.res = {
	-- 	supplies = 1000,
	-- 	colonized = false,
	-- 	population = 0,
	-- 	techlevel = 0,
	-- 	defence = 0,
	-- 	generators = 0
	-- }
	-- group:insert(p)
	-- p:addEventListener('touch', selectPlanet)
	-- table.insert(group.planets, p)


	-- Neptune
	local p = display.newImageRect("i/neptune.png", 160, 160)
	p.x, p.y = screenW/1.5, screenH/1.5
	p.r = 75
	p.speed = 0.01
	p.x0, p.y0 = 100, screenH - 100
	p.orbit = 7500
	p.alphaR = 90
	p.fullName = "Neptune"
	p.name = "neptune"
	p.nameType = "planet"
	p.enemy = true
	p.res = {
		supplies = 300,
		colonized = false,
		population = 0,
		techlevel = 0,
		defence = 0,
		generators = 0,
		w = 150
	}
	group:insert(p)
	p:addEventListener('touch', selectPlanet)
	table.insert(group.planets, p)
	group.neptune = p

	-- Add gravitation fields for every planet
	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if g.nameType == "planet" then -- or g.name == "sun" then
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
