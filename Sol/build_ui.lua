-----------------------------------------------------------------------------------------
--
-- build_ui.lua
--
-----------------------------------------------------------------------------------------

require "build_control"
require "balance"

-----------------------------------------------------------------------------------------
function addBuildButtons(g)
	-- Build ships buttons
	for i = 1, #shipsData, 1 do
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
