-----------------------------------------------------------------------------------------
--
-- build_ui.lua
--
-----------------------------------------------------------------------------------------

require "build_control"
require "balance"
require "minimap_ui"
require "game_ui"

-----------------------------------------------------------------------------------------
function addBuildButtons(g)
	-- Planet control

	local b = display.newText("Planet control:", 0, 0, native.systemFont, 16)
	g:insert(b)

	-- Build ships buttons
	for i = 1, 3, 1 do
		local s = shipsData[i]
		local b = display.newImageRect("ui/build/"..s.ship..".png", 70, 70)
		b:setReferencePoint(display.TopLeftReferencePoint)
		b.x, b.y = (i-1)*80, 30
		b.fullName = s.fullName
		b.ship = s.ship
		b.res = s.res
		b:addEventListener('touch', hudBuildShip)
		g:insert(b)
	end
	
	-- Tech buttons
	for i = 1, #buildData, 1 do
		local s = buildData[i]
		local b = display.newImageRect("ui/build/"..s.tech..".png", 70, 70)
		b:setReferencePoint(display.TopLeftReferencePoint)
		b.x, b.y = (i-1)*80, 110
		b.tech = s.tech
		b.res = s.res
		b:addEventListener('touch', buildTech)
		g:insert(b)
	end
end

-----------------------------------------------------------------------------------------
function addPlanetsButtons(g)
	-- Goto planet buttons

	-- local b = display.newText("Select planet:", 0, 80, native.systemFont, 16)
	-- g:insert(b)

	for i = 1, #planetsData, 1 do
		local planet = planetsData[i]
		local b = display.newImageRect("i/"..planet.name..".png", planet.size, planet.size)
		b.y = 150
		if i < 5 then
			b.x = i*55-40
		elseif i == 5 then
			b.x = i*55-20
		else
			b.x = i*65-40
		end

		b.fleetTarget = planet.name
		b:addEventListener('touch', gotoPlanet)
		g:insert(b)
	end
end

-----------------------------------------------------------------------------------------
function addGameButtons(g)
	-- Pause, Menu, etc

	local b = display.newText("Game:", 500, 0, native.systemFont, 16)
	g:insert(b)

	local b = display.newImageRect("ui/buttons/pause.png", 70, 70)
	b:setReferencePoint(display.TopLeftReferencePoint)
	b.x, b.y = 500, 30
	b:addEventListener('touch', gamePause)
	g:insert(b)

	local b = display.newImageRect("ui/buttons/menu.png", 70, 70)
	b:setReferencePoint(display.TopLeftReferencePoint)
	b.x, b.y = 580, 30
	b:addEventListener('touch', gameMenu)
	g:insert(b)

	local b = display.newImageRect("ui/buttons/empty.png", 70, 70)
	b:setReferencePoint(display.TopLeftReferencePoint)
	b.x, b.y = 660, 30
	g:insert(b)

	for i = 1, 3, 1 do
		local b = display.newImageRect("ui/buttons/empty.png", 70, 70)
		b:setReferencePoint(display.TopLeftReferencePoint)
		b.x, b.y = 500 + (i-1)*80, 110
		g:insert(b)
	end

	-- local b = display.newImageRect("ui/buttons/restart.png", 70, 70)
	-- b:setReferencePoint(display.TopLeftReferencePoint)
	-- b.x, b.y = 160, 0
	-- b:addEventListener('touch', gameRestart)
	-- g:insert(b)
end