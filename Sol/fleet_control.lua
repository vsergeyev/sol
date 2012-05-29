-----------------------------------------------------------------------------------------
--
-- fleet_control.lua
--
-----------------------------------------------------------------------------------------

require "badges"
require "notifications"
require "economy"
require "battle_ai"

local movieclip = require "movieclip"

local baseImpulse = 150
local maxImpulseMoveSize = 150
local rand = math.random
local planetToColonize, colonizationShip = nil, nil
local shipsCollisionFilter = { groupIndex = -1 }

-----------------------------------------------------------------------------------------
function buildShip(e)
	-- Builds ship on the planet
	-- or on Carrier / Station

	if isPause then return end

	local t = e.target
	local p = selectedObject
	local ship = nil

	if t.res.cost <= gold then
		-- build ship
		if t.ship == "fighter" then
			ship = movieclip.newAnim({"ships/"..t.ship..".png", "ships/"..t.ship.."2.png"})
			ship:setSpeed(0.2)
			ship:play()
		elseif t.ship == "carier" then
			ship = movieclip.newAnim({"ships/"..t.ship..".png", "ships/"..t.ship.."2.png"})
			ship:setSpeed(0.02)
			ship:play()
		else
			ship = display.newImageRect("ships/"..t.ship..".png", t.res.w, t.res.h)
		end

		ship.x, ship.y = p.x, p.y
		ship.originPlanet = p
		ship.targetPlanet = p
		ship.targetReached = true
		ship.r = 75
		if (t.ship == "trade") or (t.ship == "explorer") then
			ship.sensors = 100
		else
			ship.sensors = 300
		end
		ship.orbit = math.random(3)
		ship.alphaR = 1 -- math.random(360)
		ship.fullName = t.fullName
		ship.name = t.ship
		ship.res = t.res
		ship.hp = t.res.hp -- res.hp == max/normal/100% hp
		ship.shield = t.res.shield
		ship.nameType = "ship"
		ship.enemy = false
		ship.enemies = {}
		ship.imageRotation = t.r -- 15 -- scout image now a little rotated
		physics.addBody(ship, {radius=ship.sensors, filter=shipsCollisionFilter})
		ship.isSensor = true
		group:insert(ship)
		ship:addEventListener('touch', selectShip)
		ship:addEventListener('collision', collisionShip)
		-- ship:addEventListener('postCollision', escapeShip)

		if t.is_station then
			ship.is_station = true
			ship.isFixedRotation = true
		end

		if t.on_carrier then
			ship.on_carrier = true
			ship.rotation = p.rotation
			impulseShip(ship, 20, 10, 0.2)
		end

		gold = gold - ship.res.cost
		groupHud.money.text = gold.." MC"

		showBaloon("Ship ready: \n"..ship.fullName)
	else
		showBaloon("Need more resources: \n"..t.res.cost.." MC")
	end

	return ship
end

-----------------------------------------------------------------------------------------
function colonizeIt()
	if planetToColonize then
    	planetToColonize.res.colonized = true
    	planetToColonize.res.at = stardate
    	planetToColonize.res.population = 1000
    	addHumanBadge(planetToColonize)
    	showBaloon(planetToColonize.fullName.."\nHuman colony established")
    	planetToColonize = nil
    	timer.performWithDelay(50, function ()
    		-- clear target on linked ships
			for i = 1, group.numChildren, 1 do
				local g0 = group[i]
				if g0.nextBattleTarget == colonizationShip then
					g0.nextBattleTarget = nil
				end
				if g0.next2BattleTarget == colonizationShip then
					g0.next2BattleTarget = nil
				end
				if g0.battleTarget == colonizationShip then
					outOfBattle(g0)
				end
			end
    		colonizationShip:removeSelf()
    	end, 1 )
    end
end

function onCompleteColonization(e)
	if "clicked" == e.action then
		local i = e.index
        if 1 == i then
            planetToColonize = nil
			colonizationShip = nil
        elseif 2 == i then
        	colonizeIt()
        end
    end
end

-----------------------------------------------------------------------------------------
function collisionShip(e)
	local t = e.target
	local o = e.other

	if o.name == "planet_field" then
		-- if this is exploration ship and planet not colonized
		local planet = o.planet
		if t.name == "explorer" and planet.name ~= "sun" and not planet.res.colonized then
			t:setLinearVelocity(0, 0)
			t.targetPlanet = nil
			planetToColonize = planet
			colonizationShip = t
			colonizeIt()
			-- local alert = native.showAlert( planet.fullName, "Do you want to colonize this planet?", 
   --                                      { "Not now", "Create colony" }, onCompleteColonization )
		elseif t.name == "trade" and planet.name ~= "sun" and planet.res.colonized and planet == t.targetPlanet and not t.targetReached and t.targetPlanet ~= t.originPlanet then
			-- this is trader, so +1C and target him back to origin planet
			tradeIncome()
			t.targetPlanet = t.originPlanet
			t.originPlanet = planet
			t.targetReached = false
		elseif t.nameType == "ship" and planet == t.targetPlanet and not t.targetReached then
			-- showBaloon(t.fullName.."\n"..planet.fullName.." reached")
			t.targetReached = true
			t:setLinearVelocity(0, 0)
		end
	elseif o.nameType == "ship" and t.res.attack > 0 then
		if t.enemy ~= o.enemy then
			if not t.inBattle then
				-- print(t.fullName.." collision")
				t.inBattle = true
				t.battleTarget = o
				t.battleTimer = timer.performWithDelay(1000, function ()
					-- print(t.fullName.." timer")
					shipBattle(t)
				end, 0 )
			elseif not t.nextBattleTarget then
				-- print(t.fullName.." next battle target")
				t.nextBattleTarget = o
			else
				-- print(t.fullName.." next@2 battle target")
				t.next2BattleTarget = o
			end
			-- table.insert(t.enemies, o)
			-- showBaloon("Our ship engaged the enemy")
			-- local alert = native.showAlert( "Encountered aliens battleship!", "Start battle or retreat to nearest planet?", { "Retreat", "Fight" }, onCompleteBattle )
		end
	end
end

-----------------------------------------------------------------------------------------
-- function escapeShip(e)
-- 	local t = e.target
-- 	local o = e.other

-- 	if t.enemies[o] then
-- 		table.remove(t.enemies, o)
-- 		print(t.enemies[1].fullName)
-- 	end
-- end

-----------------------------------------------------------------------------------------
function impulseShip(t, dx, dy, speed)
	-- used in selectShip
	local length = math.sqrt(dx*dx + dy*dy)

    if length > 0 then
        local xI = dx / length;
        local yI = dy / length;

        if length > maxImpulseMoveSize then
        	length = maxImpulseMoveSize
        end
        local k = length / maxImpulseMoveSize * baseImpulse * t.res.speed

        if speed then
        	k = k * speed
        end

    	-- t:applyLinearImpulse(xI*k, yI*k, t.x, t.y)
    	-- print(xI*k)
    	-- print(yI*k)
    	t:setLinearVelocity(xI*k, yI*k)
    end
end

-----------------------------------------------------------------------------------------
local arrows = {}
function selectShip( e )
	if isPause then return end

	local t = e.target
	local phase = e.phase

	local arrow = arrows[e.id]

	touchesPinch[ e.id ]  = nil

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

		if e.target.enemy then return true end
		if e.target.name == "fighter" then return true end
		--

		-- Stop ship
		t.targetPlanet = nil
		t.targetReached = false
		--

		-- Display line
		display.getCurrentStage():setFocus( t, e.id )
		t.isFocus = true
		-- print(t:getLinearVelocity())
        t:setLinearVelocity(0,0)

        arrows[e.id] = nil

        oneTouchBegan = true
    elseif t.isFocus then
    	local dx = e.x-e.xStart
	    local dy = e.y-e.yStart

		if arrow then
			arrow:removeSelf()
		end

		if "moved" == phase then
			-- TODO: draw arrow end
			-- TODO: limit arrow length
			-- TODO: fix target center
			-- local arrow = display.newLine(t.x,t.y, (e.x - group.x)/group.xScale, (e.y - group.y)/group.yScale )
			-- arrow.width = 3
			-- group:insert(arrow)
			-- arrows[e.id] = arrow

			t.rotation = - t.res.r + math.deg(math.atan2( -t.y + (e.y - group.y)/group.xScale, -t.x + (e.x - group.x)/group.yScale)) -- - t.imageRotation
			-- print(t.rotation)
		
		elseif "ended" == phase or "cancelled" == phase then
			oneTouchBegan = false

			-- arrows[e.id] = nil

			t.isFocus = false
			display.getCurrentStage():setFocus( t, e.id )
	    	
			impulseShip(t, dx, dy)
		end
	elseif "ended" == phase or "cancelled" == phase then
		oneTouchBegan = false
    end

    return true
end

-----------------------------------------------------------------------------------------
function targetShips(e)
	-- Autopilot ships to target planets

	if isPause then return end

	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if g.nameType == "ship" then
			if not g.inBattle and g.targetPlanet and not g.targetReached then
				-- ship auto-piloting to planet
				local planet = g.targetPlanet
				g.rotation = math.deg(math.atan2((planet.y - g.y), (planet.x - g.x)))
				local k = 1
				if g.name == "fighter" then
					k = 0.1
				end
				impulseShip(g, planet.x-g.x, planet.y-g.y, k)
				-- print(g.fullName.." go to planet "..g.targetPlanet.fullName)
			end
		end
	end
end

function repairCarrier()
	-- repair ships if it NOT in battle

	if isPause then return end

	-- local g = group.carrier

	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if g.nameType == "ship" and g.res.attack > 0 then
			if not g.inBattle then
				if g.shield < g.res.shield then
					g.shield = g.shield + 10
					if g.shield > g.res.shield then
						g.shield = g.res.shield
					end
				end

				if g.hp < g.res.hp then
					g.hp = g.hp + 1
				end

				if selectedObject == g then
					showInfo(g)
				end
			end
		end
	end
end