-----------------------------------------------------------------------------------------
--
-- info.lua
--
-----------------------------------------------------------------------------------------

infoPedia = {
	sun = "", -- [[The Sun is the star at the center of the Solar System. It is almost perfectly spherical and consists of hot plasma interwoven with magnetic fields. It has a diameter of about 1,392,000 km, about 109 times that of Earth, and its mass (about 2×1030 kilograms, 330,000 times that of Earth) accounts for about 99.86% of the total mass of the Solar System. Chemically, about three quarters of the Sun's mass consists of hydrogen, while the rest is mostly helium.]],
	mercury = [[Mercury]],
	earth = [[The Earth is the third planet from the Sun, and the densest and fifth-largest of the eight planets in the Solar System.
It is also the largest of the Solar System's four terrestrial planets.]],
	moon = [[The Moon is the only natural satellite of the Earth, and the fifth largest satellite in the Solar System.]],
	venus = [[Venus]],
	mars = [[Mars]],
	explorer = [[Exploration vessel used to colonize planets]],
	trade = [[Freighter to deliver goods and materials between planets]],
	fighter = [[Fast fighter]],
	cruiser = [[Heavy gunship]],
	carier = [[Heavy fighters carrier USS "Discovery" is the flagship of Earth Alliance Fleet.
It is the most advanced and biggest battleship in the Solar System. And it's under your command, Captain.]],
	aliens = [[Aliens battleship]],
	station = [[Space station with heavy lasers.]],
}


function format_value(n) -- credit http://richard.warburton.it
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right
end

-----------------------------------------------------------------------------------------
function showInfo( item )
	-- Show info about item in hud
	if item and item ~= selectedObject then
		if selectOverlay then
			selectOverlay:removeSelf()
			selectOverlay = nil
		end
		createOverlay(item, item.res.w/2)
	elseif not item and selectOverlay then
		selectOverlay:removeSelf()
		selectOverlay = nil
    end
    selectedObject = item

	groupHud.money.text = gold.." MC" --..energy.."E | Date: "..stardate

	if item then
		if item.fullName then
			groupHud.title.text = item.fullName
		else
			groupHud.title.text = item.name:sub(1,1):upper()..item.name:sub(2)
		end
		groupHud.text.text = ""

		-- print(item.nameType)
		if item.nameType == "planet" then
			groupHud.fleet.alpha = 0
			groupHud.planets.alpha = 0
			
			-- Planet info
			if item.res.colonized then
				local p = format_value(item.res.population)
				groupHud.build.alpha = 1
				groupHud.text.text = "Population: "..p
			else
				groupHud.build.alpha = 0
				groupHud.text.text = ""
			end
		elseif item.nameType == "asteroid" then
			groupHud.fleet.alpha = 0
			groupHud.planets.alpha = 0
			groupHud.text.text = ""
			if item.explored then
				groupHud.text.text = "[Already explored]"
			end
		elseif item.nameType == "ship" then
			groupHud.build.alpha = 0
			groupHud.planets.alpha = 0
			if not item.enemy then
				groupHud.fleet.alpha = 1
			end
			groupHud.fleet.fighter.alpha = 0
			groupHud.fleet.fighterText.alpha = 0

			if item.name == "carier" then
				-- Carrier can build fighters/droids
				groupHud.fleet.fighter.alpha = 1
				groupHud.fleet.fighterText.alpha = 1
			elseif item.name == "station" then
				-- Battle station can build fighters
				groupHud.fleet.fighter.alpha = 1
				groupHud.fleet.fighterText.alpha = 1
			end
			
			-- Ship details
			groupHud.text.text = "HP: "..item.hp.."/"..item.res.hp.."\nShield: "..item.shield.."/"..item.res.shield
		else
			groupHud.build.alpha = 0
			groupHud.fleet.alpha = 0
			groupHud.planets.alpha = 0
			groupHud.text.text = infoPedia[item.name]
		end
	else
		groupHud.title.text = ""
		groupHud.text.text = ""
		groupHud.build.alpha = 0
		groupHud.fleet.alpha = 0
		groupHud.planets.alpha = 1
	end
end