-----------------------------------------------------------------------------------------
--
-- hud.lua
--
-----------------------------------------------------------------------------------------

require "info"


local baseImpulse = 0.4
local maxImpulseMoveSize = 1
local rand = math.random


function hudBuildShip( e )
	if e.phase == 'began' then
		local ship = display.newImageRect("ships/scout.png", 150, 67)
		ship.x, ship.y = selectedObject.x, selectedObject.y
		ship.r = 75
		ship.name = "scout"
		ship.imageRotation = 15 -- scout image now a little rotated
		group:insert(ship)
		ship:addEventListener('touch', selectShip)
		physics.addBody(ship, {})
		-- table.insert(ships, ship)
	end

	return true
end

-- local arrows = {}

function selectShip( e )
	local t = e.target
	local phase = e.phase

	-- local arrow = arrows[e.id]

	if phase == 'began' then
		-- Shine overlay
		if selectOverlay then
			selectOverlay:removeSelf()
			selectOverlay = nil
		end
		
		-- selectOverlay = display.newCircle(t.x, t.y, t.r)
		-- selectOverlay.alpha = 0.3
		-- selectOverlay.strokeWidth = 5
		-- selectOverlay:setStrokeColor(255)
		-- group:insert(selectOverlay)
		-- t.overlay = selectOverlay

		selectedObject = t
		showInfo(t)
		--

		display.getCurrentStage():setFocus( t, e.id )
		t.isFocus = true
		-- print(t:getLinearVelocity())
        t:setLinearVelocity(0,0)

        -- arrows[e.id] = nil

    elseif t.isFocus then

    	local dx = e.x-e.xStart
	    local dy = e.y-e.yStart

		-- if arrow then
		-- 	arrow:removeSelf()
		-- end

		if "moved" == phase then
			-- TODO: draw arrow end
			-- TODO: limit arrow length
			-- TODO: fix target center
			-- local arrow = display.newLine(t.x,t.y, e.xStart + dx, e.yStart + dy )
			-- arrow.width = 3
			-- arrows[e.id] = arrow

			t.rotation = math.deg(math.atan2((e.y - t.y), (e.x - t.x))) - t.imageRotation
			-- print(t.rotation)
		
		elseif "ended" == phase or "cancelled" == phase then

			-- arrows[e.id] = nil

			t.isFocus = false
			display.getCurrentStage():setFocus( t, e.id )
	    	
	        local length = math.sqrt(dx*dx + dy*dy)
	        if length > 0 then
		        local xI = dx / length;
		        local yI = dy / length;

		        if length > maxImpulseMoveSize then
		        	length = maxImpulseMoveSize
		        end
		        local k = length / maxImpulseMoveSize * baseImpulse

		    	t:applyLinearImpulse(xI*k, yI*k, t.x, t.y)
	        end
		end
    end

    return true
end