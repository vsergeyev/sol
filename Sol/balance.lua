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
			e = 10
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
			e = 10
		}
	},
	{
		fullName = "Fighters squadron",
		ship = "fighters",
		res = {
			hp = 200,
			speed = 2,
			attack = 10,
			cost = 200,
			e = 20
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
			e = 50
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