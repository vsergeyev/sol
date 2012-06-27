-----------------------------------------------------------------------------------------
--
-- build_ui.lua
--
-----------------------------------------------------------------------------------------

require "fleet_control"


function addFleetButtons(g)
	-- Fleet control buttons
	-- local b = display.newText("Autopilot", 330, 0, native.systemFont, 16)
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
		b:addEventListener('touch', hudFleetControl)
		g:insert(b)
		
		local t = display.newText(planet.name, x-30, 56, native.systemFont, 12)
		t:setTextColor(0, 200, 100)
		g:insert(t)
	end

	-- Carrirer UI buttons
	-- local b = display.newText("Build", 500, 0, native.systemFont, 16)
	-- g:insert(b)
	-- build Fighter button for Carrier
	local s = shipsData[4]
	local b = display.newImageRect("ui/build/"..s.ship..".png", 70, 70)
	b:setReferencePoint(display.TopLeftReferencePoint)
	b.x, b.y = 650, 3
	b.fullName = s.fullName
	b.ship = s.ship
	b.res = s.res
	b.on_carrier = true
	b:addEventListener('touch', hudBuildShip)
	g:insert(b)
	g.fighter = b
	
	local t = display.newText(s.ship.." ("..s.res.cost..")", b.x+2, b.y+53, native.systemFont, 12)
	t:setTextColor(0, 200, 100)
	g:insert(t)
	g.fighterText = t

	-- build Droid
	-- local s = shipsData[7]
	-- local b = display.newImageRect("ui/build/"..s.ship..".png", 70, 70)
	-- b:setReferencePoint(display.TopLeftReferencePoint)
	-- b.x, b.y = 660, 0
	-- b.fullName = s.fullName
	-- b.ship = s.ship
	-- b.res = s.res
	-- b.on_carrier = true
	-- b:addEventListener('touch', hudBuildShip)
	-- g:insert(b)
	-- g.droid = b

	-- show details
	-- local b = display.newImageRect("ui/buttons/details.png", 70, 70)
	-- b:setReferencePoint(display.TopLeftReferencePoint)
	-- b.x, b.y = 660, 0
	-- b:addEventListener('touch', hudDetails)
	-- g:insert(b)
	-- g.details = b
end
