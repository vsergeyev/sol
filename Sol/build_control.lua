-----------------------------------------------------------------------------------------
--
-- build_control.lua
--
-----------------------------------------------------------------------------------------

require "info"
require "badges"
require "notifications"
require "planet_control"

local techs = {
	one = "Automated production of all goods",
	two = "AI researched. Full robotization of plants.",
	three = "Nano robots researched",
	four = "",
	fixe = "",
	siz = "",
}

-----------------------------------------------------------------------------------------
function buildTech(e)
	local t = e.target
	local s = selectedObject
	
	if e.phase == "ended" then
		if s then
			if t.tech == "planet_control" then
				isPause = true
				physics.pause()
				planetScreen()
			elseif t.tech == "tech" then
				s.res.techlevel = s.res.techlevel + 1
				showBaloon(s.fullName.."\nTech level improved")
			elseif t.tech == "energy" then
				s.res.generators = s.res.generators + 1
				showBaloon(s.fullName.."\nNuclear plant built")
			elseif t.tech == "defence" and s.res.defence < 10 then
				s.res.defence = s.res.defence + 1
				addDefenceBadge(s)
				showBaloon(s.fullName.."\nDefence improved")
			end
			
			showInfo(s)
		end
	end
	
	return true
end