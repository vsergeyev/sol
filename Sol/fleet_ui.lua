-----------------------------------------------------------------------------------------
--
-- build_ui.lua
--
-----------------------------------------------------------------------------------------

require "fleet_control"


function addFleetButtons(g)
	-- Fleet control buttons
	local b = display.newText("Autopilot ship to:", 0, 80, native.systemFont, 16)
	g:insert(b)

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
		b:addEventListener('touch', hudFleetControl)
		g:insert(b)
	end

	-- Carrirer UI buttons
	local b = display.newText("Ship control:", 500, 0, native.systemFont, 16)
	g:insert(b)
	-- build Fighter button for Carrier
	local s = shipsData[4]
	local b = display.newImageRect("ui/build/"..s.ship..".png", 70, 70)
	b:setReferencePoint(display.TopLeftReferencePoint)
	b.x, b.y = 500, 30
	b.fullName = s.fullName
	b.ship = s.ship
	b.res = s.res
	b.on_carrier = true
	b:addEventListener('touch', hudBuildShip)
	g:insert(b)
	g.fighter = b

	-- build Droid
	local s = shipsData[7]
	local b = display.newImageRect("ui/build/"..s.ship..".png", 70, 70)
	b:setReferencePoint(display.TopLeftReferencePoint)
	b.x, b.y = 580, 30
	b.fullName = s.fullName
	b.ship = s.ship
	b.res = s.res
	b.on_carrier = true
	b:addEventListener('touch', hudBuildShip)
	g:insert(b)
	g.droid = b

	-- show details
	local b = display.newImageRect("ui/buttons/details.png", 70, 70)
	b:setReferencePoint(display.TopLeftReferencePoint)
	b.x, b.y = 660, 30
	b:addEventListener('touch', hudDetails)
	g:insert(b)
	g.details = b
end
