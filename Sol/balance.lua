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
			speed = 1,
			attack = 0,
			cost = 100,
			e = 10,
			w = 100,
			h = 100,
			r = 0,
			autofigth = false
		}
	},
	{
		fullName = "Trade ship",
		ship = "trade",
		res = {
			hp = 80,
			speed = 1,
			attack = 0,
			cost = 80,
			e = 10,
			w = 100,
			h = 100,
			r = 0,
			autofigth = false
		}
	},
	{
		fullName = "Fighter",
		ship = "fighter",
		res = {
			hp = 20,
			speed = 2,
			attack = 1,
			cost = 20,
			e = 2,
			w = 30,
			h = 30,
			r = 0,
			autofigth = true
		}
	},
	{
		fullName = "Battlecruiser",
		ship = "cruiser",
		res = {
			hp = 500,
			speed = 1,
			attack = 20,
			cost = 500,
			e = 50,
			w = 100,
			h = 100,
			r = 0,
			autofigth = true
		},
	},
	{
		fullName = "Carier",
		ship = "carier",
		res = {
			hp = 2000,
			speed = 0.3,
			attack = 0,
			cost = 5000,
			e = 500,
			w = 200,
			h = 90,
			r = 15,
			autofigth = false
		},
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
	{
		tech = "planet_control",
		res = {
			cost = 0,
			e = 0
	}
	},
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