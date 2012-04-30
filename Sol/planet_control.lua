-----------------------------------------------------------------------------------------
--
-- planet_control.lua
--
-----------------------------------------------------------------------------------------

require "info"
require "notifications"

-----------------------------------------------------------------------------------------
function planetInfo(infoText, planet)
	if planet.res.colonized then
		local p = planet.res.population
		if p > 1000000000 then
			p = math.ceil(p / 1000000000).." Blns"
		elseif p > 1000000 then
			p = math.ceil(p / 1000000).." Mlns"
		end

		if planet.name ~= "earth" then
			infoText.text = "Colonized in: "..planet.res.at.."\n"
		end

		infoText.text = infoText.text.."Population: "..p.."\nTech. level: "..planet.res.techlevel.."\nEnergy: "..planet.res.generators.."\nDefence: "..planet.res.defence
	else
		infoText.text = "Bonus resources: "..planet.res.supplies.."\n\nNOT COLONIZED"
	end
end

-----------------------------------------------------------------------------------------
function planetScreen()
	-- displays a detail of selected planet
	local planet = selectedObject

	local p = display.newGroup()
	local dx, dy = 50, 50

	local dlg = display.newRoundedRect(50, 50, screenW-100, screenH-100, 10)
	dlg:setFillColor(0)
	dlg.alpha = 0.9
	p:insert(dlg)

	local infoTitle = display.newText(planet.fullName, dx + 20, dy + 20, 180, 40, native.systemFont, 24)
	p:insert(infoTitle)

	local e = display.newImageRect("i/"..planet.name..".png", 100, 100)
	e.x, e.y = screenW-dx-70, dy + 70
	p:insert(e)

	local infoText = display.newText("", dx + 20, dy + 60, 280, 400, native.systemFont, 12)
	p:insert(infoText)
	infoText.text = ""

	planetInfo(infoText, planet)
end