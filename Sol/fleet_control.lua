-----------------------------------------------------------------------------------------
--
-- fleet_control.lua
--
-----------------------------------------------------------------------------------------

local baseImpulse = 50
local maxImpulseMoveSize = 50
local rand = math.random
local planetToColonize, colonizationShip = nil, nil

-----------------------------------------------------------------------------------------
function buildShip(e)
	-- Builds ship on the planet
	local ship = display.newImageRect("ships/"..e.target.ship..".png", 100, 100)
	ship.x, ship.y = selectedObject.x, selectedObject.y
	ship.r = 75
	ship.name = e.target.ship
	ship.res = e.target.res
	ship.nameType = "ship"
	ship.enemy = false
	-- ship.imageRotation = 15 -- scout image now a little rotated
	physics.addBody(ship, {radius=20, friction=0.1})
	-- ship.linearDamping = 1
	group:insert(ship)
	ship:addEventListener('touch', selectShip)
	ship:addEventListener('collision', collisionShip)
	-- table.insert(ships, ship)
end

-----------------------------------------------------------------------------------------
function onCompleteColonization(e)
	if "clicked" == e.action then
		local i = e.index
        if 1 == i then
            -- Do nothing; dialog will simply dismiss
        elseif 2 == i then
        	if planetToColonize then
            	planetToColonize.res.colonized = true
            	planetToColonize.res.population = 1000
            	planetToColonize = nil
            	colonizationShip:removeSelf()
            end
        end
    end
end

-----------------------------------------------------------------------------------------
function collisionShip(e)
	local t = e.target
	local o = e.other

	if o.name == "planet_field" then
		-- stop ship
		-- t.linearDamping = planetGraviationDamping
		-- t:setLinearVelocity(xI*k, yI*k)

		-- if this is exploration ship and planet not colonized
		local planet = o.planet
		if t.name == "explorer" and not planet.res.colonized then
			t:setLinearVelocity(0, 0)
			planetToColonize = planet
			colonizationShip = t
			local alert = native.showAlert( "Colonize "..planet.name, "Do you want to colonize this planet?", 
                                        { "Not now", "Create colony" }, onCompleteColonization )
		end
	end
end

-----------------------------------------------------------------------------------------
function impulseShip(t, dx, dy)
	-- used in selectShip
	local length = math.sqrt(dx*dx + dy*dy)

    if length > 0 then
        local xI = dx / length;
        local yI = dy / length;

        if length > maxImpulseMoveSize then
        	length = maxImpulseMoveSize
        end
        local k = length / maxImpulseMoveSize * baseImpulse

    	-- t:applyLinearImpulse(xI*k, yI*k, t.x, t.y)
    	-- print(xI*k)
    	-- print(yI*k)
    	t:setLinearVelocity(xI*k, yI*k)
    end
end

-----------------------------------------------------------------------------------------
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

			t.rotation = math.deg(math.atan2((e.y - t.y), (e.x - t.x))) -- - t.imageRotation
			-- print(t.rotation)
		
		elseif "ended" == phase or "cancelled" == phase then

			-- arrows[e.id] = nil

			t.isFocus = false
			display.getCurrentStage():setFocus( t, e.id )
	    	
			impulseShip(t, dx, dy)

	      --   local length = math.sqrt(dx*dx + dy*dy)
	      --   if length > 0 then
		     --    local xI = dx / length;
		     --    local yI = dy / length;

		     --    if length > maxImpulseMoveSize then
		     --    	length = maxImpulseMoveSize
		     --    end
		     --    local k = length / maxImpulseMoveSize * baseImpulse

		    	-- t:applyLinearImpulse(xI*k, yI*k, t.x, t.y)
	      --   end
		end
    end

    return true
end

-----------------------------------------------------------------------------------------
function colonizePlanet( e )

end
