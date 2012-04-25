-----------------------------------------------------------------------------------------
--
-- build_ui.lua
--
-----------------------------------------------------------------------------------------

require "fleet_control"


function addFleetButtons(g)
	-- Fleet control buttons
	local b = display.newText("Ship control:", 0, 0, native.systemFont, 16)
	g:insert(b)
	
	for i = 1, #planetsData, 1 do
		local name = planetsData[i]:sub(1,1):upper()..planetsData[i]:sub(2)

		local x, y = 0, 40*i - 10
		if i > 4 then
			x, y = 200, 40*(i-4) - 10
		end

		local b = display.newText(name, x, y, native.systemFont, 16)
		b.fleetTarget = planetsData[i]
		b:addEventListener('touch', hudFleetControl)
		g:insert(b)
	end
end
