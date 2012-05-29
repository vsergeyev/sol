-----------------------------------------------------------------------------------------
--
-- minimap_ui.lua
--
-----------------------------------------------------------------------------------------

require "info"

local mdx, mdy = 5, 5
local mapW, mapH = 180*1.4, 135*1.4
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
	group.x = ((halfW - e.x + mdx + 5 + minimap.x) * 80) * group.xScale
	group.y = ((halfH - e.y + mdy + 7 + groupHud.y - 110) * 80) * group.yScale

	--if e.phase == "moved" then
	refreshMinimap(e)
	--end

	return true
end

-----------------------------------------------------------------------------------------
function addMinimap()
	-- dirty way to make map bg non-transparent on semitransparent group
	local map = display.newRect(mdx, mdy, mapW, mapH)
	map.name = "map"
	map:setFillColor(0)
	map.alpha = 0.1
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
		local x = g.x*zx + mdx - 5 + halfW
		local y = g.y*zy + mdy - 10 + halfH
		local obj = nil

		if g.name == "sun" then
			obj = display.newRect(x, y, 10, 10)
			--obj:setFillColor(255)
			obj:setFillColor(0, 200, 100)
		elseif g.nameType == "planet" then
			obj = display.newRect(x, y, 6, 6)
			obj:setFillColor(0, 200, 100)
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

	local x = -group.x*zx*group.xScale + mdx - 20 + halfW
	local y = -group.y*zy*group.yScale + mdy - 20 + halfH
	local f = display.newRect(x, y, screenW/systemSizeX, screenH/systemSizeY)
	f:setFillColor(0, 255, 0)
	f.alpha=0.5
	minimap:insert(f)
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

	refreshMinimap(e)
end