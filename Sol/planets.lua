-----------------------------------------------------------------------------------------
--
-- planets.lua
--
-----------------------------------------------------------------------------------------

-- local planetsDb = {
-- 	mercury = {
		
-- 	}
-- }

function addPlanets()
	-- Mercury
	local p = display.newImageRect("i/mercury.png", 60, 60)
	p.x, p.y = screenW/1.5, screenH/1.5
	p.r = 30
	p.speed = 2
	p.x0, p.y0 = 100, screenH - 100
	p.orbit = 600
	p.alphaR = 0
	p.name = "mercury"
	p.nameType = "planet"
	p.res = {
		colonized = false,
		population = 0,
		techlevel = 0,
		defence = 0,
		generators = 0
	}
	group:insert(p)
	p:addEventListener('touch', selectPlanet)


	-- Venus
	local p = display.newImageRect("i/venus.png", 80, 80)
	p.x, p.y = screenW/1.5, screenH/1.5
	p.r = 40
	p.speed = 1.5
	p.x0, p.y0 = 100, screenH - 100
	p.orbit = 1200
	p.alphaR = 270
	p.name = "venus"
	p.nameType = "planet"
	p.res = {
		colonized = false,
		population = 0,
		techlevel = 0,
		defence = 0,
		generators = 0
	}
	group:insert(p)
	p:addEventListener('touch', selectPlanet)


	-- Earth
	local earth = display.newImageRect("i/earth.png", 100, 100)
	earth.x, earth.y = screenW/1.5, screenH/1.5
	earth.r = 50
	earth.speed = 1
	earth.x0, earth.y0 = 100, screenH - 100 -- 0, screenH
	earth.orbit = 2000
	earth.alphaR = 90
	earth.name = "earth"
	earth.nameType = "planet"
	earth.res = {
		colonized = true,
		population = 7 * 1000000000,
		techlevel = 1,
		defence = 1,
		generators = 1
	}
	group:insert(earth)
	earth:addEventListener('touch', selectPlanet)


	-- Moon
	local moon = display.newImageRect("i/moon.png", 30, 30)
	moon.x, moon.y = screenW/1.5, screenH/1.5
	moon.r = 15
	moon.speed = 10
	moon.x0, moon.y0 = earth.x, earth.y
	moon.orbit = 200
	moon.alphaR = 90
	moon.name = "moon"
	moon.nameType = "moon" -- "planet"
	moon.res = {
		colonized = false,
		population = 0,
		techlevel = 0,
		defence = 0,
		generators = 0
	}
	group:insert(moon)
	moon:addEventListener('touch', selectPlanet)

	earth.moon = moon


	-- Mars
	local p = display.newImageRect("i/mars.png", 100, 100)
	p.x, p.y = screenW/1.5, screenH/1.5
	p.r = 50
	p.speed = 0.2
	p.x0, p.y0 = 100, screenH - 100
	p.orbit = 3000
	p.alphaR = 120
	p.name = "mars"
	p.nameType = "planet"
	p.res = {
		colonized = false,
		population = 0,
		techlevel = 0,
		defence = 0,
		generators = 0
	}
	group:insert(p)
	p:addEventListener('touch', selectPlanet)

	-- Jupiter
	local p = display.newImageRect("i/jupiter.png", 150, 150)
	p.x, p.y = screenW/1.5, screenH/1.5
	p.r = 75
	p.speed = 0.1
	p.x0, p.y0 = 100, screenH - 100
	p.orbit = 5000
	p.alphaR = 200
	p.name = "jupiter"
	p.nameType = "planet"
	p.res = {
		colonized = false,
		population = 0,
		techlevel = 0,
		defence = 0,
		generators = 0
	}
	group:insert(p)
	p:addEventListener('touch', selectPlanet)

	-- Add gravitation fields for every planet
	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if g.nameType == "planet" or g.name == "sun" then
			local gr = display.newCircle(g.x, g.y, planetGravitationFieldRadius)
			gr.name = "planet_field"
			gr.alpha = 0.1
			group:insert(gr)
			physics.addBody(gr, {friction=planetGraviationDamping, radius=planetGravitationFieldRadius})
			gr.isSensor = true
			gr.planet = g
			g.field = gr
		end
	end
end