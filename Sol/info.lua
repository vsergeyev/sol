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
	scout = [[Light exploration ship]],
	cruiser = [[Heavy gunship]],
}

function showInfo( item )
	groupHud.alpha = 1
	groupHud.title.text = item.name:sub(1,1):upper()..item.name:sub(2)
	groupHud.text.text = infoPedia[item.name]
	groupHud.money.text = "$"..gold.." E"..energy

	-- print(item.nameType)
	if item.nameType == "planet" then
		groupHud.build.alpha = 1
		-- TODO: Show build buttons
		-- Hide othe buttons (ship control, etc)
	-- elseif item.nameType == "ship" then
	else
		groupHud.build.alpha = 0
		-- TODO: Hide build buttons
		-- Show ship control buttons
	end
end