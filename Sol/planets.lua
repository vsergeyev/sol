-----------------------------------------------------------------------------------------
--
-- planets.lua
--
-----------------------------------------------------------------------------------------

function addPlanets()
	-- Earth
	local earth = display.newImageRect("i/earth.png", 100, 100)
	earth.x, earth.y = screenW/1.5, screenH/1.5
	earth.r = 50
	earth.speed = 1
	earth.x0, earth.y0 = 0, screenH
	earth.orbit = 800
	earth.alphaR = 90
	earth.name = "earth"
	earth.nameType = "planet"
	group:insert(earth)
	earth:addEventListener('touch', selectPlanet)


	-- Mercury
	local p = display.newImageRect("i/mercury.png", 60, 60)
	p.x, p.y = screenW/1.5, screenH/1.5
	p.r = 30
	p.speed = 2
	p.x0, p.y0 = 100, screenH - 100
	p.orbit = 400
	p.alphaR = 0
	p.name = "mercury"
	p.nameType = "planet"
	group:insert(p)
	p:addEventListener('touch', selectPlanet)


	-- Venus
	local p = display.newImageRect("i/venus.png", 80, 80)
	p.x, p.y = screenW/1.5, screenH/1.5
	p.r = 40
	p.speed = 1.5
	p.x0, p.y0 = 100, screenH - 100
	p.orbit = 600
	p.alphaR = 270
	p.name = "venus"
	p.nameType = "planet"
	group:insert(p)
	p:addEventListener('touch', selectPlanet)


	-- Mars
	local p = display.newImageRect("i/mars.png", 100, 100)
	p.x, p.y = screenW/1.5, screenH/1.5
	p.r = 50
	p.speed = 1
	p.x0, p.y0 = 100, screenH - 100
	p.orbit = 1000
	p.alphaR = 120
	p.name = "mars"
	p.nameType = "planet"
	group:insert(p)
	p:addEventListener('touch', selectPlanet)
end