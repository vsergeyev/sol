-----------------------------------------------------------------------------------------
--
-- hud.lua
--
-----------------------------------------------------------------------------------------

require "info"
require "build_ui"
require "fleet_control"
require "fleet_ui"
require "minimap_ui"

-----------------------------------------------------------------------------------------
function addHud()
	local infoPanel = display.newRect(0, 0, screenW, 200)
	infoPanel:setFillColor( 127 )

	local infoTitle = display.newText("", 10, 10, 180, 20, native.systemFont, 16)
	local infoText = display.newText("", 10, 40, 280, 200, native.systemFont, 12)

	-- Resources
	local infoMoney = display.newText("", screenW-100, 10, 180, 20, native.systemFont, 16)
	infoMoney:setTextColor(200, 200, 80)
	infoMoney.text = "C"..gold.." E"..energy

	groupHud:insert(infoPanel)
	groupHud:insert(infoTitle)
	groupHud:insert(infoText)
	groupHud:insert(infoMoney)

	groupHud.x = 0
	groupHud.y = screenH-200
	groupHud.title = infoTitle
	groupHud.text = infoText
	groupHud.money = infoMoney

	-- Build Buttons
	local build = display.newGroup()
	groupHud:insert(build)
	addBuildButtons(build)
	build.x, build.y = 310, 10
	groupHud.build = build
	build.alpha = 0

	-- Command Fleet
	local fleet = display.newGroup()
	groupHud:insert(fleet)
	addFleetButtons(fleet)
	fleet.x, fleet.y = 310, 10
	groupHud.fleet = fleet
	fleet.alpha = 0

	-- Minimap
	minimap = display.newGroup()
	groupHud:insert(minimap)
	addMinimap()
	minimap.x, minimap.y = screenW-200, 10
	minimap.alpha = 1

	-- Main Hud Alpha
	groupHud.alpha = 0.5	
end

-----------------------------------------------------------------------------------------
function hudBuildShip( e )
	if e.phase == 'began' then
		buildShip(e)
	end

	return true
end

-----------------------------------------------------------------------------------------
function hudFleetControl( e )
	-- Target and move all ships on-screen like selected
	-- to the planet
	 
	local planet = nil
	local planet_name = e.target.fleetTarget

	for i = 1, group.numChildren, 1 do
		if group[i].name == planet_name then
			planet = group[i]
			break
		end
	end
	
	local g = selectedObject
	g.rotation = math.deg(math.atan2((planet.y - g.y), (planet.x - g.x)))
	impulseShip(g, planet.x-g.x, planet.y-g.y)
	
	if false and planet then
		for i = 1, group.numChildren, 1 do
			if group[i].nameType == "ship" then
				local g = group[i]
				g.rotation = math.deg(math.atan2((planet.y - g.y), (planet.x - g.x)))
				impulseShip(g, planet.x-g.x, planet.y-g.y)
			end
		end
	end

	return true
end
