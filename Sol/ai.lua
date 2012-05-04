-----------------------------------------------------------------------------------------
--
-- ai.lua
--
-----------------------------------------------------------------------------------------

require "balance"
require "notifications"
require "build_control"

local currentPlanet = nil
local currentCarier = nil

local planetNames = {"mercury", "venus", "earth", "mars"}

-----------------------------------------------------------------------------------------
local function findPlanet(colonized)
	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if g.nameType == "planet" and g ~= currentPlanet and g.res.colonized == colonized and g~=group.neptune then
			-- it must be planet
			-- colonized or not
			-- not equal to current planet
			-- not an enemy base
			return g
		end
	end

	return nil
end

-----------------------------------------------------------------------------------------
local function findOurPlanet()
	local name = math.random(#planetNames)

	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if g.name == planetNames[name] and g.res.colonized then
			return g
		end
	end
end

-----------------------------------------------------------------------------------------
local function findCarier()
	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if g.name == "carier" then
			return g
		end
	end

	return nil
end

-----------------------------------------------------------------------------------------
local function colonizePlanet()
	local planet = findPlanet(false)
	
	if not planet then return false end

	-- build colonization ship
	selectedObject = currentPlanet
	local ship = buildShip({target=shipsData[1]})
	ship.targetPlanet = planet
	ship.targetReached = false
end

-----------------------------------------------------------------------------------------
function tradeWithPlanet()
	local planet = findPlanet(true)

	if not planet then return false end

	-- build trade ship
	selectedObject = currentPlanet
	local ship = buildShip({target=shipsData[2]})
	ship.targetPlanet = planet
	ship.targetReached = false
end

-----------------------------------------------------------------------------------------
function buildBattleShip(shipType)
	local planet = nil

	if currentCarier then
		planet = currentCarier
	else
		planet = findPlanet(true)
	end

	if not planet then return false end

	-- build battle ship
	selectedObject = planet
	local ship = buildShip({target=shipsData[shipType]})
	-- put ship into battle: target it to the enemy base
	if not currentCarier then
		ship.targetPlanet = group.neptune
		ship.targetReached = false
	end
end

-----------------------------------------------------------------------------------------
function aiTurn()
	local action = math.random(25)

	if action < 3 then
		-- colonize planets
		currentPlanet = group.earth
		colonizePlanet()
		print("Explorer")
	elseif action < 8 then
		-- build trade ship
		currentPlanet = nil
		currentPlanet = findPlanet(true)
		tradeWithPlanet()
		print("Trader")
	elseif action < 10 then
		-- build fighter
		currentCarier = nil
		currentPlanet = nil
		buildBattleShip(3)
		print("Fighter")
	elseif action < 19 then
		-- build fighter on the cruiser
		currentPlanet = nil
		currentCarier = findCarier()
		buildBattleShip(3)
		print("Carier: Fighter")
	elseif action < 21 then
		-- build carier
		if not findCarier() then
			currentCarier = nil
			currentPlanet = nil
			buildBattleShip(5)
			print("Carier")
		end
	elseif action < 25 then
		-- upgrade planetary defence
		selectedObject = findOurPlanet()
		if selectedObject then
			buildTech({target={tech="defence"}, phase="ended"})
			print("Defence "..selectedObject.name)
		end
	end
end