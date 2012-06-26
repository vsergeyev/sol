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
	local function addBtn(i)
		local s = shipsData[i]
		local b = display.newImageRect("ui/build/"..s.ship..".png", 70, 70)
		b:setReferencePoint(display.TopLeftReferencePoint)
		b.x, b.y = (i-4)*75, 3
		if i > 3 then
			b.x = (i-5)*75
		end
		b.fullName = s.fullName
		b.ship = s.ship
		b.res = s.res
		b:addEventListener('touch', hudBuildShip)
		g:insert(b)

		local s = s.ship
		if s.ship == "carier" then
			s = "carrier"
		end
		local t = display.newText(s, b.x+2, b.y+53, native.systemFont, 12)
		t:setTextColor(0, 200, 100)
		g:insert(t)
	end

	-- Build ships buttons
	for i = 1, 3, 1 do
		addBtn(i)
	end
	
	for i = 5, 6, 1 do
		addBtn(i)
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
		local x = i*65-40
		b.y = 38
		if i < 6 then
			x = 238 + i*74
		elseif i == 5 then
			x = i*55-20
		end

		b.x = x

		b.fleetTarget = planet.name
		b:addEventListener('touch', gotoPlanet)
		g:insert(b)
		
		local t = display.newText(planet.name, x-30, 56, native.systemFont, 12)
		t:setTextColor(0, 200, 100)
		g:insert(t)
	end
end

-----------------------------------------------------------------------------------------
function addGameButtons(g)
	-- Pause, Menu, etc

	-- local b = display.newText("Game", 500, 0, native.systemFont, 16)
	-- g:insert(b)

	local b = display.newImageRect("ui/buttons/pause.png", 70, 70)
	b:setReferencePoint(display.TopLeftReferencePoint)
	b.x, b.y = 650, 3
	b:addEventListener('touch', gamePause)
	g:insert(b)

	-- local b = display.newImageRect("ui/buttons/menu.png", 70, 70)
	-- b:setReferencePoint(display.TopLeftReferencePoint)
	-- b.x, b.y = 650, 3
	-- b:addEventListener('touch', gameMenu)
	-- g:insert(b)

	-- local b = display.newImageRect("ui/buttons/empty.png", 70, 70)
	-- b:setReferencePoint(display.TopLeftReferencePoint)
	-- b.x, b.y = 660, 0
	-- g:insert(b)

	-- for i = 1, 3, 1 do
	-- 	local b = display.newImageRect("ui/buttons/empty.png", 70, 70)
	-- 	b:setReferencePoint(display.TopLeftReferencePoint)
	-- 	b.x, b.y = 500 + (i-1)*80, 110
	-- 	g:insert(b)
	-- end

	-- local b = display.newImageRect("ui/buttons/restart.png", 70, 70)
	-- b:setReferencePoint(display.TopLeftReferencePoint)
	-- b.x, b.y = 160, 0
	-- b:addEventListener('touch', gameRestart)
	-- g:insert(b)
end