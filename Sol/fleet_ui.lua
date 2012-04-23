-----------------------------------------------------------------------------------------
--
-- build_ui.lua
--
-----------------------------------------------------------------------------------------

function addFleetButtons(g)
	-- Fleet control buttons
	local b = display.newText("Fleet control:", 0, 0, native.systemFont, 16)
	g:insert(b)
	
	local b = display.newText("Mercury", 0, 30, native.systemFont, 16)
	b.fleetTarget = "mercury"
	b:addEventListener('touch', hudFleetControl)
	g:insert(b)

	local b = display.newText("Venus", 0, 60, native.systemFont, 16)
	b.fleetTarget = "venus"
	b:addEventListener('touch', hudFleetControl)
	g:insert(b)

	local b = display.newText("Earth", 0, 90, native.systemFont, 16)
	b.fleetTarget = "earth"
	b:addEventListener('touch', hudFleetControl)
	g:insert(b)

	local b = display.newText("Mars", 0, 120, native.systemFont, 16)
	b.fleetTarget = "mars"
	b:addEventListener('touch', hudFleetControl)
	g:insert(b)

	local b = display.newText("Jupiter", 0, 150, native.systemFont, 16)
	b.fleetTarget = "jupiter"
	b:addEventListener('touch', hudFleetControl)
	g:insert(b)
end
