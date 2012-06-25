-----------------------------------------------------------------------------------------
--
-- battle_ai.lua
--
-----------------------------------------------------------------------------------------

require "notifications"

local soundBlaster = audio.loadStream("sounds/blaster.m4a")

-----------------------------------------------------------------------------------------
function outOfBattle(g)
	-- ship go out of battle

	if not g.battleTimer then return true end

	g.battleTarget = nil

	g.inBattle = false
	if not g.on_carrier then
		g.targetReached = false
	end

	if g.battleTimer then
		timer.cancel( g.battleTimer )
		g.battleTimer = nil
	end

	g.isBodyActive = false
	timer.performWithDelay(100, function (e)
		g.isBodyActive = true
	end, 1)

end

-----------------------------------------------------------------------------------------
function destroyShip(g)
	showBaloon(g.fullName.." destroyed")
	-- print(g.fullName.." destroyed")

	if g == selectedObject then
		selectedObject = nil
		if selectOverlay then
			selectOverlay:removeSelf()
			selectOverlay = nil
		end
	end

	if g.battleTimer then
		timer.cancel( g.battleTimer )
		g.battleTimer = nil
	end

	-- clear target on linked ships
	for i = 1, group.numChildren, 1 do
		local g0 = group[i]
		if g0.battleTarget == g then
			outOfBattle(g0)
		end
	end

	if g.name == "portal" then
		portalDestroyed = true
	end

	g:removeSelf()
end

-----------------------------------------------------------------------------------------
function moveShipAI(g)
	-- move for enemy ships

	if math.random(10) > 7 then
		g.y0 = math.random(100)
	end

	g.alphaR = g.alphaR + 0.3*g.res.speed

	local x = g.x0 + g.r*g.orbit * math.sin(g.alphaR)
	local y = g.y0 + g.r*g.orbit/3 * math.cos(g.alphaR)

	if g.is_station or g.res.is_station then
		g.rotation = 0
	else
		-- g.rotation = math.deg(math.atan2((g.y0 - g.y), (g.x0 - g.x)))
		g.rotation = math.deg(math.atan2((y - g.y), (x - g.x)))
	end

	if g.name == "fighter" then
		impulseShip(g, x-g.x, y-g.y, 0.15)
	else
		impulseShip(g, x-g.x, y-g.y, 0.3)
	end
end

-----------------------------------------------------------------------------------------
function attackShipAI(g)
	-- Attack ship
	--   animated explosion if shield == 0
	--   or animated shield splash, if ship has shield points
	-- Drawn blaster line: blue - ours, red - enemies

	if isPause then return end

	local t = g.battleTarget
	local shieldAttacked = false
	local dx, dy = 0, 0 -- point on ship, where atack made

	if g.res.attack then -- and math.random(10) > 5 then
		-- piu-piu
		if t.shield > 0 then
			t.shield = t.shield - g.res.attack	
			if t.shield < 0 then
				t.shield = 0
			end
			-- specify kind of attack animation
			shieldAttacked = true
		else
			t.hp = t.hp - g.res.attack
			if t.hp < 0 then
				t.hp = 0
			end
		end
		
		dx = - 30 + math.random(60)
		dy = - 30 + math.random(60)

		-- blaster line
		local arrow = display.newLine(g.x,g.y, t.x + dx, t.y + dy )
		arrow.width = 1
		if g.enemy then
			arrow:setColor(255, 0, 0)
		else
			arrow:setColor(0, 0, 255)
		end
		group:insert(arrow)
		
		transition.to(arrow, {time=500, alpha=0, onComplete=function ()
			arrow:removeSelf()
		end})

		-- BOM!!!
		local explosion = nil
		if shieldAttacked then -- Shield splash animation
			explosion = display.newImageRect("i/shield.png", t.res.w*1.3, t.res.h*1.3)
			explosion.x, explosion.y = t.x, t.y
			explosion.rotation = t.rotation
			explosion.alpha = 0.1

			group:insert(explosion)

			transition.to(explosion, {time=100, alpha=0.3})
			transition.to(explosion, {delay=100, time=200, alpha=0, onComplete=function ()
				explosion:removeSelf()
			end})
		else -- Explosion, ship hul
			-- audio.play(soundBlaster)
			
			local expl = math.random(3)
			if expl == 1 then
				explosion = display.newImageRect("i/explosion.png", 130, 85)
			elseif expl == 2 then
				explosion = display.newImageRect("i/explosion2.png", 72, 72)
			else
				explosion = display.newImageRect("i/explosion3.png", 63, 63)
			end
			explosion:scale(0.1, 0.1)
			explosion.alpha = 0.1
			explosion.x, explosion.y = t.x + dx, t.y + dy

			group:insert(explosion)

			transition.to(explosion, {time=100, alpha=1, xScale=0.5, yScale=0.5, y=explosion.y-20})
			transition.to(explosion, {delay=100, time=200, alpha=0.1, xScale=0.1, yScale=0.1, onComplete=function ()
				explosion:removeSelf()
			end})
		end
	end
end

-----------------------------------------------------------------------------------------
function shipBattle(ship)
	-- called by timer for particular ship
	if isPause then return end

	local target = ship.battleTarget

	if target then
		-- ship fighing
		-- print(target.fullName)
		-- print(target.x)
		-- print(target.y)

		if not target.x then
			outOfBattle(ship)
			return true
		end

		ship.x0, ship.y0 = target.x, target.y

		local length = 1 * math.sqrt((ship.x0-ship.x)*(ship.x0-ship.x) + (ship.y0-ship.y)*(ship.y0-ship.y))

		-- Movement
		if ship.enemy or ship.res.autofigth then
			moveShipAI(ship)
		end

		-- Attack
		attackShipAI(ship)

		-- Destroyed?
		if target.hp <= 0 then
			destroyShip(target)
			
			outOfBattle(ship)
		end

		-- Update info
		if target == selectedObject then
			showInfo(selectedObject)
		end

		if length > ship.sensors then
			-- we have lost target
			-- outOfBattle(ship)
		end
	else
		timer.cancel( ship.battleTimer )
		ship.battleTimer = nil
	end
end

-----------------------------------------------------------------------------------------
function attackPlanetAI(g, t)
	if isPause then return end

	if g.res.attack then
		-- piu-piu
		if t.res.population > 0 then
			k = 100
			if t.res.population > 1000000000 then
				k = 100000
			elseif t.res.population > 1000000 then
				k = 10000
			end
			t.res.population = t.res.population - k*g.res.attack
			if t.res.population < 0 or t.res.population == 0 then
				t.res.population = 0
				t.res.colonized = false
				t.badgeHuman:removeSelf()
				t.badgeHuman = nil
				g.targetReached = false
				for i = 1, #group.planets, 1 do
					local gp = group.planets[i]
					if gp.res and gp.res.colonized then
						g.targetPlanet = gp
						break
					end
				end
			end
		end
		
		dx = -2*p.r + math.random(4*p.r)
		dy = -2*p.r + math.random(4*p.r)

		-- blaster line
		local arrow = display.newLine(g.x,g.y, t.x + dx, t.y + dy )
		arrow.width = 1
		arrow:setColor(255, 0, 0)
		group:insert(arrow)
		
		transition.to(arrow, {time=500, alpha=0, onComplete=function ()
			arrow:removeSelf()
		end})

		-- BOM!!!
		local explosion = nil
		-- audio.play(soundBlaster)
		
		local expl = math.random(3)
		if expl == 1 then
			explosion = display.newImageRect("i/explosion.png", 130, 85)
		elseif expl == 2 then
			explosion = display.newImageRect("i/explosion2.png", 72, 72)
		else
			explosion = display.newImageRect("i/explosion3.png", 63, 63)
		end
		explosion:scale(0.1, 0.1)
		explosion.alpha = 0.1
		explosion.x, explosion.y = t.x + dx, t.y + dy

		group:insert(explosion)

		transition.to(explosion, {time=100, alpha=1, xScale=0.5, yScale=0.5, y=explosion.y-20})
		transition.to(explosion, {delay=100, time=200, alpha=0.1, xScale=0.1, yScale=0.1, onComplete=function ()
			explosion:removeSelf()
		end})
	
		if (t == selectedObject) then
			showInfo(t)
		end
	end
end
