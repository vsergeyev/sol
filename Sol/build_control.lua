-----------------------------------------------------------------------------------------
--
-- build_cpntrol.lua
--
-----------------------------------------------------------------------------------------

require "info"

-----------------------------------------------------------------------------------------
function buildTech(e)
	local t = e.target
	local s = selectedObject
	
	if e.phase == "ended" then
		if s then
			if t.tech == "tech" then
				s.res.techlevel = s.res.techlevel + 1
			elseif t.tech == "energy" then
				s.res.generators = s.res.generators + 1
			elseif t.tech == "defence" then
				s.res.defence = s.res.defence + 1
			end
			
			showInfo(s)
		end
	end
	
	return true
end