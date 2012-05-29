-----------------------------------------------------------------------------------------
--
-- economy.lua
--
-----------------------------------------------------------------------------------------

require "info"
require "notifications"

-----------------------------------------------------------------------------------------
function calcIncome()
	-- calculates how much $ and E are added to balance
	-- used per 10/secs
	
	if isPause then return end

	local c = 0
	local e = 0

	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if g.nameType == "planet" then
			c = c + math.ceil(g.res.population / 100000000)
			e = e + g.res.generators

			-- population grows
			local p = g.res.population
			if p > 10000000000 then
				p = p
			elseif p > 1000000000 then
				p = p + math.random(0, 1000000)
			elseif p > 1000000 then
				p = p + math.random(0, 10000)
			else
				p = p + math.random(0, p)
			end
			g.res.population = p
		end
	end

	-- gold = gold + c
	-- energy = energy + e

	showInfo(selectedObject)
	-- showBaloon("Income: \n+"..c.."Megacredits \n+"..e.."Energy")
end

-----------------------------------------------------------------------------------------
function tradeIncome()
	gold = gold + 10

	showInfo(selectedObject)
	showBaloon("Harvested resources: \n10 MC")
end

-----------------------------------------------------------------------------------------
function stardateGo()
	if isPause then return end
	
	stardate = stardate + 100.2
	showInfo(selectedObject)

	print(string.format( "memUsage = %.3f KB", collectgarbage( "count" ) ))
	-- print(system.getInfo( "textureMemoryUse" ))
end