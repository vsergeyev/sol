-----------------------------------------------------------------------------------------
--
-- build_ui.lua
--
-----------------------------------------------------------------------------------------

require "build_control"
require "balance"
require "minimap_ui"

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
		b.x, b.y = (i-1)*80, 100
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
		b.x, b.y = 240 + (i-1)*80, 100
		b.tech = s.tech
		b.res = s.res
		b:addEventListener('touch', buildTech)
		g:insert(b)
	end
end

function addPlanetsButtons(g)
	-- Goto planet buttons

	local b = display.newText("Select planet:", 0, 0, native.systemFont, 16)
	g:insert(b)

	for i = 1, #planetsData, 1 do
		local planet = planetsData[i]
		local b = display.newImageRect("i/"..planet.name..".png", planet.size, planet.size)
		b.y = 50
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