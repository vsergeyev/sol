-----------------------------------------------------------------------------------------
--
-- battle_ai.lua
--
-----------------------------------------------------------------------------------------

require "notifications"

-----------------------------------------------------------------------------------------
function outOfBattle(g)
	-- ship go out of battle

	g.battleTarget = nil

	if g.nextBattleTarget then
		g.battleTarget = g.nextBattleTarget
		g.nextBattleTarget = nil
		if g.next2BattleTarget then
			g.nextBattleTarget = g.next2BattleTarget
			g.next2BattleTarget = nil
		end

		return
	end

	g.inBattle = false
	g.targetReached = false
	-- local vx, vy = g:getLinearVelocity()
	-- g:setLinearVelocity(vx/5, vy/5)

	if g.battleTimer then
		timer.cancel( g.battleTimer )
		g.battleTimer = nil
	end

	print(g.fullName.." timer stoped")
end

-----------------------------------------------------------------------------------------
function destroyShip(g)
	showBaloon(g.fullName.." destroyed")

	if g == selectedObject then
		selectedObject = nil
	end

	if g.battleTimer then
		timer.cancel( g.battleTimer )
		g.battleTimer = nil
	end

	-- clear target on linked ships
	for i = 1, group.numChildren, 1 do
		local g0 = group[i]
		if g0.nextBattleTarget == g then
			g0.nextBattleTarget = nil
		end
		if g0.next2BattleTarget == g then
			g0.next2BattleTarget = nil
		end
		if g0.battleTarget == g then
			outOfBattle(g0)
		end
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

	if g.is_station then
		g.rotation = 0
	else
		-- g.rotation = math.deg(math.atan2((g.y0 - g.y), (g.x0 - g.x)))
		g.rotation = math.deg(math.atan2((y - g.y), (x - g.x)))
	end

	impulseShip(g, x-g.x, y-g.y, 0.3)
end

-----------------------------------------------------------------------------------------
function attackShipAI(g)
	-- attack
	local t = g.battleTarget

	if g.res.attack then -- and math.random(10) > 5 then
		-- piu-piu
		t.hp = t.hp - g.res.attack
		
		-- blaster
		local arrow = display.newLine(g.x,g.y, t.x, t.y )
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
		local explosion = display.newImageRect("i/explosion.png", 130, 85)
		explosion:scale(0.1, 0.1)
		explosion.alpha = 0.1
		explosion.x, explosion.y = t.x - 30 + math.random(60), t.y - 30 + math.random(60)
		
		group:insert(explosion)

		transition.to(explosion, {time=100, alpha=1, xScale=0.5, yScale=0.5, y=explosion.y-20})
		transition.to(explosion, {delay=100, time=200, alpha=0.1, xScale=0.1, yScale=0.1, onComplete=function ()
			explosion:removeSelf()
		end})
	end
end

-----------------------------------------------------------------------------------------
function shipBattle(ship)
	-- called by timer for particular ship

	local target = ship.battleTarget

	if target then
		-- ship fighing
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