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
require "discovery_detail"

-----------------------------------------------------------------------------------------
function addHud()
	local infoPanel = display.newImageRect("ui/hud.png", screenW, 200)
	infoPanel:setReferencePoint(display.TopLeftReferencePoint)
	infoPanel.x, infoPanel.y = 0, -110
	infoPanel:setFillColor( 127 )
	-- infoPanel:addEventListener('touch', function() return true end)

	-- Selected object info
	local infoTitle = display.newText("", 280, 10, 180, 20, native.systemFont, 16)
	infoTitle:setTextColor(0, 200, 100)
	local infoText = display.newText("", 280, 40, 300, 200, native.systemFont, 12)
	infoText:setTextColor(0, 200, 100)

	-- Resources
	local infoMoney = display.newText("", screenW-100, 100-screenH, 220, 20, native.systemFont, 12)
	infoMoney:setTextColor(200, 200, 80)

	groupHud:insert(infoPanel)
	groupHud:insert(infoTitle)
	groupHud:insert(infoText)
	groupHud:insert(infoMoney)

	groupHud.x = 0
	groupHud.y = screenH-90
	groupHud.title = infoTitle
	groupHud.text = infoText
	groupHud.money = infoMoney

	-- Minimap
	minimap = display.newGroup()
	groupHud:insert(minimap)
	addMinimap()
	minimap.x, minimap.y = 0, -110
	minimap.alpha = 1

	-- Planets fast buttons
	local planets = display.newGroup()
	groupHud:insert(planets)
	addPlanetsButtons(planets)
	addGameButtons(planets)
	planets.x, planets.y = 280, 10
	groupHud.planets = planets
	planets.alpha = 0

	-- Build Buttons
	local build = display.newGroup()
	groupHud:insert(build)
	addBuildButtons(build)
	build.x, build.y = 780, 10
	groupHud.build = build
	build.alpha = 0

	-- Command Fleet
	local fleet = display.newGroup()
	groupHud:insert(fleet)
	addFleetButtons(fleet)
	fleet.x, fleet.y = 280, 10
	groupHud.fleet = fleet
	fleet.alpha = 0

	-- Main Hud Alpha
	groupHud.alpha = 0.8	
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
	-- Target and move selected ship
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
	g.targetPlanet = planet
	g.targetReached = false
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

-----------------------------------------------------------------------------------------
function hudDetails(e)
	-- show Details window for selected object
	if e.phase == 'ended' then
		gamePause(e)
		detailScreen()
	end

	return true
end