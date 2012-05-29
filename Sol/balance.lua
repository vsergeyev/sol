-----------------------------------------------------------------------------------------
--
-- balance.lua
--
-- Cost, HP, Attack, Speed for ships and buildings
--
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
shipsData = {
	{
		fullName = 'USS "E.C.S." colonists ship',
		ship = "explorer",
		res = {
			hp = 20,
			shield = 20,
			speed = 0.5,
			attack = 0,
			cost = 20,
			e = 10,
			w = 111,
			h = 40,
			r = 0,
			autofigth = false
		}
	},
	{
		fullName = 'USS "Minecrafter" freighter',
		ship = "trade",
		res = {
			hp = 80,
			shield = 20,
			speed = 0.5,
			attack = 0,
			cost = 50,
			e = 10,
			w = 75,
			h = 22,
			r = 0,
			autofigth = false
		}
	},
	{
		fullName = 'Defence Starbase "Norad"',
		ship = "station",
		res = {
			hp = 2000,
			shield = 500,
			speed = 0.05,
			attack = 5,
			cost = 200,
			e = 20,
			w = 50,
			h = 50,
			r = 0,
			autofigth = true
		},
		is_station = true
	},
	{
		fullName = "Fighter",
		ship = "fighter",
		res = {
			hp = 20,
			shield = 20,
			speed = 4,
			attack = 5,
			cost = 10,
			e = 2,
			w = 30,
			h = 18,
			r = 0,
			autofigth = true
		}
	},
	{
		fullName = "Battlecruiser",
		ship = "cruiser",
		res = {
			hp = 500,
			shield = 0,
			speed = 0.3,
			attack = 10,
			cost = 500,
			e = 50,
			w = 150,
			h = 48,
			r = 0,
			autofigth = true
		},
	},
	{
		fullName =  'USS "Discovery" carrier', --'USS "Discovery"',
		ship = "carier",
		res = {
			class = "Carrier",
			origin = "Earth",
			staff = 5000,
			hp = 2000,
			shield = 500,
			fighters_max = 10,
			droids_max = 2,
			speed = 0.5,
			attack = 10,
			cost = 500,
			e = 500,
			w = 248,
			h = 50,
			r = 0,
			autofigth = false
		},
	},
	{
		fullName = 'Repair droid R2D2',
		ship = "droid",
		res = {
			class = "Droid",
			hp = 50,
			shield = 20,
			speed = 2,
			attack = 0,
			cost = 50,
			e = 5,
			w = 15,
			h = 15,
			r = 0,
			autofigth = false
		},
	},
}

aliensData = {
	{
		fullName = "Alien heavy fighter",
		name = "fighter",
		ship = "aliens",
		res = {
			hp = 50,
			shield = 10,
			speed = 2,
			attack = 3,
			cost = 20,
			e = 2,
			w = 30,
			h = 18,
			r = 0,
			autofigth = true
		}
	},
	{
		fullName = "Alien cruiser",
		name = "cruiser",
		ship = "aliens",
		res = {
			hp = 200,
			shield = 0,
			speed = 1.5,
			attack = 10,
			cost = 200,
			e = 20,
			w = 150,
			h = 53,
			r = 0,
			autofigth = true
		}
	},
}

-----------------------------------------------------------------------------------------
buildData = {
	{
		tech = "tech",
		res = {
			cost = 100,
			e = 10
		}
	},
	{
		tech = "energy",
		res = {
			cost = 100,
			e = 10
		}
	},
	{
		tech = "defence",
		res = {
			cost = 100,
			e = 10
		}
	},
	-- {
	-- 	tech = "planet_control",
	-- 	res = {
	-- 		cost = 0,
	-- 		e = 0
	-- 	}
	-- },
}

-----------------------------------------------------------------------------------------
planetsData = {
	{
		name = "mercury",
		size = 60,
	},
	{
		name = "venus",
		size = 60,
	},
	{
		name = "earth",
		size = 60,
	},
	{
		name = "moon",
		size = 60,
	},
	-- {
	-- 	name = "mars",
	-- 	size = 35,
	-- },
	-- {
	-- 	name = "jupiter",
	-- 	size = 60,
	-- },
	-- {
	-- 	name = "saturn",
	-- 	size = 100,
	-- },
	-- {
	-- 	name = "uranus",
	-- 	size = 35,
	-- },
	-- {
	-- 	name = "neptune",
	-- 	size = 25,
	-- }
}