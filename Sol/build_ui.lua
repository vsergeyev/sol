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
	-- Build ships buttons
	for i = 1, 3, 1 do
		local s = shipsData[i]
		local b = display.newImageRect("ui/build/"..s.ship..".png", 70, 70)
		b:setReferencePoint(display.TopLeftReferencePoint)
		b.x, b.y = (i-1)*80, 0
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
		b.x, b.y = (i-1)*80, 80
		b.tech = s.tech
		b.res = s.res
		b:addEventListener('touch', buildTech)
		g:insert(b)
	end
end

function addPlanetsButtons(g)
	local b = display.newText("Goto planet:", 0, 0, native.systemFont, 16)
	g:insert(b)
	
	for i = 1, #planetsData, 1 do
		local name = planetsData[i]:sub(1,1):upper()..planetsData[i]:sub(2)

		local x, y = 0, 40*i - 10
		if i > 4 then
			x, y = 200, 40*(i-4) - 10
		end

		local b = display.newText(name, x, y, native.systemFont, 16)
		b.fleetTarget = planetsData[i]
		b:addEventListener('touch', gotoPlanet)
		g:insert(b)
	end
end