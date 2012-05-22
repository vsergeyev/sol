-----------------------------------------------------------------------------------------
--
-- minimap_ui.lua
--
-----------------------------------------------------------------------------------------

require "info"

local mapW, mapH = 180, 135
local systemSizeX, systemSizeY = 20, 20 -- Sol system size in screenW/H
local zx, zy = mapW/(screenW*systemSizeX), mapH/(screenH*systemSizeY) -- zoom of map
local halfW, halfH = mapW/2, mapH/2

-----------------------------------------------------------------------------------------
function gotoMinimap( e )
	if selectedObject and selectedObject.nameType == "ship" then
		selectedObject = nil
		showInfo(nil)
	end
	-- center Solar system to the point on minimap
	group.x = (halfW - e.x + 15 + minimap.x) * 120
	group.y = (halfH - e.y + 52 + groupHud.y) * 120

	return true
end

-----------------------------------------------------------------------------------------
function addMinimap()
	-- dirty way to make map bg non-transparent on semitransparent group
	local map = display.newRect(10, 45, mapW, mapH)
	map.name = "map"
	map:setFillColor(0)
	minimap:insert(map)
	local map = display.newRect(10, 45, mapW, mapH)
	map.name = "map"
	map:setFillColor(0)
	minimap:insert(map)
	local map = display.newRect(10, 45, mapW, mapH)
	map.name = "map"
	map:setFillColor(0)
	minimap:insert(map)

	map:addEventListener('touch', gotoMinimap)
end

-----------------------------------------------------------------------------------------
function refreshMinimap(e)
	-- remove old objects on map
	for i = minimap.numChildren, 1, -1 do
		if not minimap[i].name then
			minimap[i]:removeSelf()
		end
	end

	for i = 1, group.numChildren, 1 do
		local g = group[i]
		local x = g.x*zx + 5 + halfW
		local y = g.y*zy + 35 + halfH
		local obj = nil

		if g.name == "sun" then
			obj = display.newRect(x, y, 10, 10)
			obj:setFillColor(255)
		elseif g.nameType == "planet" then
			obj = display.newRect(x, y, 6, 6)
			obj:setFillColor(0, 0, 200)
		elseif g.enemy then
			obj = display.newRect(x, y, 3, 3)
			obj:setFillColor(255, 0, 0)
		elseif g.nameType and g.nameType == "ship" then
			obj = display.newRect(x, y, 3, 3)
		end
		if obj then
			minimap:insert(obj)
		end
	end
end

-----------------------------------------------------------------------------------------
function gotoPlanet(e)
	local planet_name = e.target.fleetTarget

	for i = 1, group.numChildren, 1 do
		if group[i].name == planet_name then
			planet = group[i]
			break
		end
	end
	group.x, group.y = group.xScale*-planet.x + screenW/2, group.yScale*-planet.y + screenH/2
end