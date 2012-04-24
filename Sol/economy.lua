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
	local c = 0
	local e = 0

	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if g.nameType == "planet" then
			c = c + math.ceil(g.res.population / 100000000)
			e = e + g.res.generators
		end
	end

	gold = gold + c
	energy = energy + e

	showInfo(selectedObject)

	showBaloon("Income: \n+"..c.."Megacredits \n+"..e.."Energy")
end
