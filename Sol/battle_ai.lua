-----------------------------------------------------------------------------------------
--
-- battle_ai.lua
--
-----------------------------------------------------------------------------------------

require "notifications"

-----------------------------------------------------------------------------------------
function outOfBattle(g)
	g.battleTarget = nil
	g.inBattle = false
	g.targetReached = false
end

-----------------------------------------------------------------------------------------
function destroyShip(g)
	g.isBodyActive = false
	g.inBattle = false

	showBaloon(g.fullName.." destroyed")
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

	-- g.rotation = math.deg(math.atan2((g.y0 - g.y), (g.x0 - g.x)))
	g.rotation = math.deg(math.atan2((y - g.y), (x - g.x)))

	impulseShip(g, x-g.x, y-g.y, 0.2)
end

-----------------------------------------------------------------------------------------
function attackShipAI(g)
	-- attack

	if g.res.attack then -- and math.random(10) > 5 then
		-- piu-piu
		g.battleTarget.res.hp = g.battleTarget.res.hp - g.res.attack
		
		-- blaster
		local arrow = display.newLine(g.x,g.y, g.battleTarget.x, g.battleTarget.y )
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
		explosion.x, explosion.y = g.battleTarget.x, g.battleTarget.y
		
		group:insert(explosion)

		transition.to(explosion, {time=100, alpha=1, xScale=1, yScale=1, y=explosion.y-20})
		transition.to(explosion, {delay=100, time=200, alpha=0.1, xScale=0.5, yScale=0.5, onComplete=function ()
			explosion:removeSelf()
		end})
	end
end