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
		fullName = "Colonization ship",
		ship = "explorer",
		res = {
			hp = 50,
			speed = 0.5,
			attack = 0,
			cost = 100,
			e = 10,
			w = 111,
			h = 40,
			r = 0,
			autofigth = false
		}
	},
	{
		fullName = "Trade ship",
		ship = "trade",
		res = {
			hp = 80,
			speed = 0.5,
			attack = 0,
			cost = 80,
			e = 10,
			w = 150,
			h = 45,
			r = 0,
			autofigth = false
		}
	},
	{
		fullName = "Fighter",
		ship = "fighter",
		res = {
			hp = 20,
			speed = 4,
			attack = 5,
			cost = 20,
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
		fullName = 'USS "Discovery"',
		ship = "carier",
		res = {
			class = "Carrier",
			origin = "Earth",
			staff = 5000,
			hp = 2000,
			shield = 0,
			fighters_max = 10,
			droids_max = 2,
			speed = 0.5,
			attack = 0,
			cost = 5000,
			e = 500,
			w = 248,
			h = 50,
			r = 0,
			autofigth = false
		},
	},
}

aliensData = {
	{
		fullName = "Alien fighter",
		name = "fighter",
		ship = "aliens",
		res = {
			hp = 50,
			speed = 2,
			attack = 5,
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
	"mercury",
	"venus",
	"earth",
	"mars",
	"jupiter",
	"saturn",
	"uranus",
	"neptune"
}