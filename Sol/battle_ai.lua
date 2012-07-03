-----------------------------------------------------------------------------------------
--
-- battle_ai.lua
--
-----------------------------------------------------------------------------------------

require "notifications"

local soundBlaster = audio.loadStream("sounds/blaster.m4a")

-----------------------------------------------------------------------------------------
function createExplosion(x, y, e)
	local explosion = nil

	local expl = 1
	if e then
		expl = e
	else
		expl = math.random(3)
	end
	if expl == 1 then
		explosion = display.newImageRect("i/explosion.png", 130, 85)
	elseif expl == 2 then
		explosion = display.newImageRect("i/explosion2.png", 72, 72)
	else
		explosion = display.newImageRect("i/explosion3.png", 63, 63)
	end

	explosion:scale(0.1, 0.1)
	explosion.alpha = 0.1
	explosion.x, explosion.y = x, y

	group:insert(explosion)

	transition.to(explosion, {time=100, alpha=1, xScale=0.5, yScale=0.5, y=explosion.y-20})
	transition.to(explosion, {delay=100, time=200, alpha=0.1, xScale=0.1, yScale=0.1, onComplete=function ()
		explosion:removeSelf()
	end})
end

-----------------------------------------------------------------------------------------
function minusHpOrShield(g, t)
	if t.shield > 0 then
		t.shield = t.shield - g.res.attack	
		if t.shield < 0 then
			t.shield = 0
		end
		-- specify kind of attack animation
		return true
	else
		t.hp = t.hp - g.res.attack
		if t.hp < 0 then
			t.hp = 0
		end
	end
	return false
end

-----------------------------------------------------------------------------------------
function outOfBattle(g)
	-- ship go out of battle

	if not g.battleTimer then return true end

	g.battleTarget = nil
	g.linearDamping = 0

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
	g.isBodyActive = false

	if g.enemy then
		gameStat.killed = gameStat.killed + 1
	end

	if g == selectedObject then
		showInfo(nil)
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

	if g.parent then
		-- g:removeSelf()
		g.parent:remove(g)
	end
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
		-- local r = math.deg(math.atan2((y - g.y), (x - g.x)))
		-- g.rotation = g.rotation + (r - g.rotation) / 10
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
	local tx, ty, tw, th, tr = t.x, t.y, t.res.w, t.res.h, t.rotation
	local shieldAttacked = false
	local dx, dy = 0, 0 -- point on ship, where atack made

	if g.res.attack then -- and math.random(10) > 5 then
		-- piu-piu
		shieldAttacked = minusHpOrShield(g, t)
		
		dx = - 30 + math.random(60)
		dy = - 30 + math.random(60)

		if g.res.torpedos then
			local torpedo = display.newImageRect("ships/torpedo/1.png", 15, 10)
			torpedo.x, torpedo.y = g.x, g.y
			torpedo.nameType = "torpedo"
			torpedo.enemy = false
			torpedo.res = {
				speed = 5,
				ttl = 0.7,
				tx = tx,
				ty = ty,
				attack = g.res.attack
			}
			physics.addBody(torpedo, {radius=12, filter=shipsCollisionFilter})
			torpedo.isSensor = true
			group:insert(torpedo)
		else
			-- blaster line
			local arrow = nil

			if g.enemy then
				arrow = display.newImageRect("ships/blaster_red.png", 23, 6) -- display.newLine(g.x,g.y, t.x + dx, t.y + dy )
			else
				arrow = display.newImageRect("ships/blaster.png", 23, 6)
			end
			arrow.x, arrow.y = g.x, g.y
			arrow.rotation = math.deg(math.atan2((ty - g.y), (tx - g.x)))
			group:insert(arrow)
			
			transition.to(arrow, {time=250, x=tx+dx, y=ty+dy, alpha=0.5, onComplete=function ()
				arrow:removeSelf()
			
				-- BOM!!!
				local explosion = nil
				if shieldAttacked then -- Shield splash animation
					explosion = display.newImageRect("i/shield.png", tw*1.3, th*1.3)
					explosion.x, explosion.y = tx, ty
					explosion.rotation = tr
					explosion.alpha = 0.1

					group:insert(explosion)

					transition.to(explosion, {time=100, alpha=0.3})
					transition.to(explosion, {delay=100, time=200, alpha=0, onComplete=function ()
						explosion:removeSelf()
					end})
				else -- Explosion, ship hul
					-- audio.play(soundBlaster)
					createExplosion(tx + dx, ty + dy)
				end
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
		if (ship.enemy and ship.res.autofigth) or ship.res.autofigth then
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
		local arrow = display.newImageRect("ships/blaster_red.png", 23, 6)
		arrow.x, arrow.y = g.x, g.y
		arrow.rotation = math.deg(math.atan2((t.y - g.y), (t.x - g.x)))
		-- local arrow = display.newLine(g.x,g.y, t.x + dx, t.y + dy )
		-- arrow.width = 1
		-- arrow:setColor(255, 0, 0)
		group:insert(arrow)
		
		transition.to(arrow, {time=250, x=t.x+dx, y=t.y+dy, alpha=0.5, onComplete=function ()
			arrow:removeSelf()
			-- BOM!!!
			createExplosion(t.x + dx, t.y + dy)
		end})
	
		if (t == selectedObject) then
			showInfo(t)
		end
	end
end
