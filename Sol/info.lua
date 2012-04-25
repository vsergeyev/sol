-----------------------------------------------------------------------------------------
--
-- info.lua
--
-----------------------------------------------------------------------------------------

local infoPedia = {
	sun = [[The Sun is the star at the center of the Solar System. It is almost perfectly spherical and consists of hot plasma interwoven with magnetic fields.

It has a diameter of about 1,392,000 km, about 109 times that of Earth, and its mass (about 2×1030 kilograms, 330,000 times that of Earth) accounts for about 99.86% of the total mass of the Solar System.

Chemically, about three quarters of the Sun's mass consists of hydrogen, while the rest is mostly helium.
	]],
	mercury = [[Mercury]],
	earth = [[The Earth is the third planet from the Sun, and the densest and fifth-largest of the eight planets in the Solar System. It is also the largest of the Solar System's four terrestrial planets. It is sometimes referred to as the world, the Blue Planet, or by its Latin name, Terra.]],
	venus = [[Venus]],
	mars = [[Mars]],
	fighters = [[Fast fighters]],
	cruiser = [[Heavy gunship]],
	explorer = [[Exploration vessel used to colonize planets]],
}

function showInfo( item )
	-- groupHud.alpha = 0.5
	groupHud.money.text = gold.."C "..energy.."E | Date: "..stardate

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
			
			-- Planet info
			if item.res.colonized then
				local p = item.res.population
				if p > 1000000000 then
					p = math.ceil(p / 1000000000).." Blns"
				elseif p > 1000000 then
					p = math.ceil(p / 1000000).." Mlns"
				end

				groupHud.build.alpha = 1
				groupHud.text.text = "Colonized in: "..item.res.at.."\nPopulation: "..p.."\nTech. level: "..item.res.techlevel.."\nEnergy: "..item.res.generators.."\nDefence: "..item.res.defence
			else
				groupHud.text.text = "Bonus resources: "..item.res.supplies.."\n\nNOT COLONIZED"
			end
			groupHud.text.text = groupHud.text.text .. "\n\n" .. infoPedia[item.name]
		elseif item.nameType == "ship" then
			groupHud.build.alpha = 0
			groupHud.fleet.alpha = 1
			
			-- Ship details
			groupHud.text.text = "HP: "..item.res.hp.."\nAttack: "..item.res.attack.."\nWarp speed: "..item.res.speed
			groupHud.text.text = groupHud.text.text .. "\n\n" .. infoPedia[item.name]
		else
			groupHud.build.alpha = 0
			groupHud.fleet.alpha = 0
			groupHud.text.text = infoPedia[item.name]
		end
	else
		groupHud.title.text = "Solar system"
		groupHud.text.text = [[The Solar System consists of the Sun and the astronomical objects gravitationally bound in orbit around it, all of which formed from the collapse of a giant molecular cloud approximately 4.6 billion years ago.]]
		groupHud.build.alpha = 0
		groupHud.fleet.alpha = 0
	end
end