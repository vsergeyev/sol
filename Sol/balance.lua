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
		name = "E.C.S.",
		ship = "explorer",
		res = {
			hp = 20,
			shield = 20,
			speed = 0.5,
			attack = 0,
			cost = 20,
			e = 10,
			w = 150,
			h = 50,
			r = 0,
			autofigth = false,
			trailX = -55
		}
	},
	{
		fullName = 'USS "Minecrafter" freighter',
		name = "minecrafter",
		ship = "trade",
		res = {
			hp = 80,
			shield = 20,
			speed = 0.5,
			attack = 0,
			cost = 50,
			e = 10,
			w = 90,
			h = 24,
			r = 0,
			autofigth = false,
			trailX = -40
		}
	},
	{
		fullName = 'USS "Norad" starbase',
		name = "starbase",
		ship = "station",
		res = {
			hp = 2000,
			shield = 500,
			speed = 0.05,
			attack = 5,
			cost = 200,
			e = 20,
			w = 110,
			h = 130,
			r = 0,
			autofigth = true,
			is_station = true
		}
	},
	{
		fullName = 'USS "Falcon" fighter',
		name = "fighter",
		ship = "fighter",
		res = {
			hp = 40,
			shield = 0,
			speed = 4,
			attack = 5,
			cost = 10,
			e = 2,
			w = 16,
			h = 9,
			r = 0,
			autofigth = true,
			trailX = -10
		}
	},
	{
		fullName = 'USS "Eagle" destroyer',
		name = "destroyer",
		ship = "destroyer",
		res = {
			hp = 150,
			shield = 100,
			speed = 0.7,
			attack = 10,
			cost = 50,
			e = 50,
			w = 48,
			h = 25,
			r = 0,
			autofigth = false,
			trailX = -22
		},
	},
	{
		fullName = 'USS "Rhino" battleship',
		name = "cruiser",
		ship = "cruiser",
		res = {
			hp = 500,
			shield = 100,
			speed = 0.5,
			attack = 10,
			cost = 150,
			e = 50,
			w = 160,
			h = 60,
			r = 0,
			autofigth = false,
			torpedos = true
		},
	},
	{
		fullName =  'USS "Discovery" carrier', --'USS "Discovery"',
		name = "carrier",
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
			cost = 400,
			e = 500,
			w = 210,
			h = 102,
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
			hp = 60,
			shield = 0,
			speed = 1.5,
			attack = 3,
			cost = 20,
			e = 2,
			w = 18,
			h = 15,
			r = 0,
			autofigth = true
		}
	},
	{
		fullName = "Alien frigate",
		name = "frigate",
		ship = "aliens",
		res = {
			hp = 200,
			shield = 0,
			speed = 1.5,
			attack = 10,
			cost = 200,
			e = 20,
			w = 50,
			h = 50,
			r = 0,
			autofigth = true
		}
	},
	{
		fullName = "Alien battle station",
		name = "bs",
		ship = "aliens",
		res = {
			hp = 2000,
			shield = 500,
			attack = 10,
			speed = 1,
			w = 50,
			h = 50,
			autofigth = false,
			is_station = true
		}
	},
	{
		fullName = "Alien cruiser",
		name = "cruiser",
		ship = "aliens",
		res = {
			hp = 500,
			shield = 100,
			speed = 1,
			attack = 10,
			cost = 200,
			e = 20,
			w = 100,
			h = 100,
			r = 0,
			autofigth = false
		}
	},
	{
		fullName = "Alien mothership",
		name = "ms",
		ship = "aliens",
		res = {
			hp = 5000,
			shield = 1000,
			speed = 0.5,
			attack = 10,
			cost = 200,
			e = 20,
			w = 200,
			h = 200,
			r = 0,
			autofigth = false,
			max_fighters = 20
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
	{
		name = "mars",
		size = 60,
	},
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