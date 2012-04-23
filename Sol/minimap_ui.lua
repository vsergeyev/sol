-----------------------------------------------------------------------------------------
--
-- minimap_ui.lua
--
-----------------------------------------------------------------------------------------

local mapW, mapH = 180, 135
local systemSizeX, systemSizeY = 10, 10 -- Sol system size in screenW/H
local zx, zy = mapW/(screenW*systemSizeX), mapH/(screenH*systemSizeY) -- zoom of map
local halfW, halfH = mapW/2, mapH/2

-----------------------------------------------------------------------------------------
function gotoMinimap( e )
	-- center Solar system to the point on minimap
	group.x = (halfW - e.x + 5 + minimap.x) * 50
	group.y = (halfH - e.y + 50 + groupHud.y) * 50

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
		local x = g.x*zx + 0 + halfW
		local y = g.y*zy + 25 + halfH
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