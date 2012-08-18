-----------------------------------------------------------------------------------------
--
-- fleet_control.lua
--
-----------------------------------------------------------------------------------------

require "badges"
require "notifications"
require "economy"
require "battle_ai"

local movieclip = require "movieclip"

local Particles = require("lib_particle_candy")
Particles.CreateParticleType ("trail_explorer", {imagePath="ships/trail2.png", imageWidth=24, imageHeight=16, velocityStart=10, lifeTime=1000, autoOrientation=true, alphaStart=0.2, fadeInSpeed=0.5, fadeOutSpeed=-0.75, fadeOutDelay=100, killOutsideScreen = true})
Particles.CreateParticleType ("trail_trade", {imagePath="ships/trail.png", imageWidth=12, imageHeight=20, velocityStart=10, lifeTime=1000, autoOrientation=true, alphaStart=0.5, fadeInSpeed=0.5, fadeOutSpeed=-0.75, fadeOutDelay=100, killOutsideScreen = true})
Particles.CreateParticleType ("trail_destroyer", {imagePath="ships/trail.png", imageWidth=12, imageHeight=5, velocityStart=10, lifeTime=500, autoOrientation=true, alphaStart=0.5, fadeInSpeed=0.5, fadeOutSpeed=-0.75, fadeOutDelay=100, killOutsideScreen = true})
Particles.CreateParticleType ("trail_fighter", {imagePath="ships/trail.png", imageWidth=10, imageHeight=15, velocityStart=10, lifeTime=250, autoOrientation=true, alphaStart=0.5, fadeInSpeed=0.5, fadeOutSpeed=-0.75, fadeOutDelay=50, killOutsideScreen = true})
Particles.CreateParticleType ("trail_cruiser", {imagePath="ships/trail2.png", imageWidth=16, imageHeight=16, velocityStart=10, lifeTime=1000, autoOrientation=true, alphaStart=0.2, fadeInSpeed=0.5, fadeOutSpeed=-0.75, fadeOutDelay=100, killOutsideScreen = true})
Particles.CreateParticleType ("trail_carier", {imagePath="ships/trail.png", imageWidth=30, imageHeight=5, velocityStart=10, lifeTime=1000, autoOrientation=true, alphaStart=0.5, fadeInSpeed=0.5, fadeOutSpeed=-0.75, fadeOutDelay=100, killOutsideScreen = true})

local baseImpulse = 150
local maxImpulseMoveSize = 150
local rand = math.random
local planetToColonize, colonizationShip = nil, nil
local shipsCollisionFilter = { groupIndex = -1 }

local soundEngine = audio.loadStream("sounds/engine.m4a")
local soundShipReady = audio.loadStream("sounds/shipready.m4a")

-----------------------------------------------------------------------------------------
function buildShip(e, noevent)
	-- Builds ship on the planet
	-- or on Carrier / Station

	if isPause then return end

	if not noevent then
		touchesPinch[ e.id ]  = nil
	end

	local t = e.target
	local p = selectedObject
	local ship = nil

	if t.on_carrier and p.fighters >= p.res.max_fighters then
		showBaloon("Limit fighters reached")
		return true
	end

	if t.res.cost <= gold then
		-- build ship
		if t.ship == "station" then
			local p = "ships/station/"
			ship = movieclip.newAnim({p.."1.png", p.."2.png", p.."3.png", p.."4.png", p.."5.png", p.."6.png", p.."7.png", p.."8.png", p.."9.png", p.."10.png", p.."11.png", p.."12.png", p.."13.png", p.."17.png", p.."18.png"})
			ship:setSpeed(0.2)
			ship:play()
		else
			ship = display.newImageRect("ships/"..t.ship..".png", t.res.w, t.res.h)
		end
		-- ship = movieclip.newAnim({p.."0001.png", p.."0002.png", p.."0003.png", p.."0004.png", p.."0005.png", p.."0006.png", p.."0007.png", p.."0008.png", p.."0009.png", p.."0010.png", p.."0011.png", p.."0012.png", p.."0013.png", p.."0014.png", p.."0015.png", p.."0016.png", p.."0017.png", p.."0018.png", p.."0019.png", p.."0020.png", p.."0021.png", p.."0022.png", p.."0023.png", p.."0024.png", p.."0025.png", p.."0026.png", p.."0027.png", p.."0028.png", p.."0029.png"})

		ship.x, ship.y = p.x + p.r, p.y
		ship.originPlanet = p
		ship.targetPlanet = p
		ship.targetReached = true
		ship.r = 75

		-- ship.sensors = 100
		if (t.ship == "trade") or (t.ship == "explorer") then
			ship.sensors = 100
		else
			ship.sensors = 500
		end
		ship.orbit = 1.1 + math.random(20) / 10
		ship.alphaR = 1 -- math.random(360)
		ship.fullName = t.fullName
		ship.name = t.ship
		ship.res = t.res
		ship.fighters = 0
		ship.hp = t.res.hp -- res.hp == max/normal/100% hp
		ship.shield = t.res.shield
		ship.nameType = "ship"
		ship.enemy = false
		ship.enemies = {}
		ship.imageRotation = t.r -- 15 -- scout image now a little rotated
		physics.addBody(ship, {radius=ship.sensors, filter=shipsCollisionFilter})
		ship.isSensor = true
		group:insert(ship)
		ship:addEventListener('touch', selectShip)
		ship:addEventListener('collision', collisionShip)
		-- ship:addEventListener('postCollision', escapeShip)

		if t.res.is_station then
			ship.is_station = true
			ship.isFixedRotation = true
		end

		if t.on_carrier then
			ship.on_carrier = true
			ship.rotation = p.rotation
			impulseShip(ship, 20, 10, 0.2)
			p.fighters = p.fighters + 1
		end

		gold = gold - ship.res.cost
		groupHud.money.text = gold.." MC"

		showBaloon("Ship ready: \n"..ship.fullName)

		if isMusic then
			-- audio.play(soundShipReady)
		end

		gameStat.ships = gameStat.ships + 1

		-- Particles
		if (t.ship == "explorer") or (t.ship == "trade") or (t.ship == "destroyer") or (t.ship == "fighter") or (t.ship == "cruiser") or (t.ship == "carier") then
			ship.trail = "ship"..gameStat.ships
			Particles.CreateEmitter(ship.trail, 0, 0, 0, false, true, true)
			Particles.AttachParticleType(ship.trail, "trail_"..t.ship, 10, 3000, 1000)
			Particles.SetEmitterTarget(ship.trail, ship, true, -90, ship.res.trailX, 0)
			Particles.StartEmitter(ship.trail, false)
		end
	else
		showBaloon("Need more resources: \n"..t.res.cost.." MC")
	end

	return ship
end

-----------------------------------------------------------------------------------------
function colonizeIt()
	if planetToColonize then
    	planetToColonize.res.colonized = true
    	planetToColonize.res.at = stardate
    	planetToColonize.res.population = 1000
    	addHumanBadge(planetToColonize)
    	showBaloon(planetToColonize.fullName.."\nHuman colony established")
    	planetToColonize = nil
    	timer.performWithDelay(50, function ()
    		-- clear target on linked ships
			for i = 1, group.numChildren, 1 do
				local g0 = group[i]
				if g0.nextBattleTarget == colonizationShip then
					g0.nextBattleTarget = nil
				end
				if g0.next2BattleTarget == colonizationShip then
					g0.next2BattleTarget = nil
				end
				if g0.battleTarget == colonizationShip then
					outOfBattle(g0)
				end
			end
			if colonizationShip == selectedObject then
				showInfo(nil)
			end
			Particles.DeleteEmitter(colonizationShip.trail)
    		colonizationShip:removeSelf()
    	end, 1 )
    end
end

function onCompleteColonization(e)
	if "clicked" == e.action then
		local i = e.index
        if 1 == i then
            planetToColonize = nil
			colonizationShip = nil
        elseif 2 == i then
        	colonizeIt()
        end
    end
end

-----------------------------------------------------------------------------------------
function collisionShip(e)
	local t = e.target
	local o = e.other

	if o.name == "planet_field" then
		-- if this is exploration ship and planet not colonized
		local planet = o.planet
		if t.name == "explorer" and planet.name ~= "sun" and not planet.res.colonized then
			t:setLinearVelocity(0, 0)
			t.targetPlanet = nil
			planetToColonize = planet
			colonizationShip = t
			colonizeIt()
			-- local alert = native.showAlert( planet.fullName, "Do you want to colonize this planet?", 
   --                                      { "Not now", "Create colony" }, onCompleteColonization )
		elseif t.name == "trade" and planet.name ~= "sun" and planet.res.colonized and planet == t.targetPlanet and not t.targetReached and t.targetPlanet ~= t.originPlanet then
			-- this is trader, so +1C and target him back to origin planet
			tradeIncome()
			t.targetPlanet = t.originPlanet
			t.originPlanet = planet
			t.targetReached = false
		elseif t.nameType == "ship" and planet == t.targetPlanet and not t.targetReached then
			-- showBaloon(t.fullName.."\n"..planet.fullName.." reached")
			t.targetReached = true
			t:setLinearVelocity(0, 0)
		end
	elseif o.nameType == "asteroid" and not o.explored and t.name == "explorer" then
		-- bonus for reserching asteroids
		t:setLinearVelocity(0, 0)
		gold = gold + 500
		gameStat.money = gameStat.money + 500
		o.explored = true
		showInfo(selectedObject)
		showBaloon(o.fullName.." explored: \n+500 MC")
	elseif o.nameType == "ship" and t.res.attack > 0 then
		if t.enemy ~= o.enemy then
			if not t.inBattle then
				-- print(t.fullName.." collision")
				t.inBattle = true
				t.battleTarget = o
				-- print(t.fullName.." battle target ")
				-- print(o)
				t.battleTimer = timer.performWithDelay(1000 + math.random(400), function ()
					-- print(t.fullName.." timer")
					shipBattle(t)
				end, 0 )
				if t.enemy and not t.res.autofigth then
					t.linearDamping = 1
				end
			end
		end
	elseif o.nameType == "torpedo" then
		if t.enemy ~= o.enemy then
			minusHpOrShield(o, t)
			createExplosion(t.x+math.random(60)-30, t.y+math.random(60)-30, 3)
			timer.performWithDelay(5, function ()
				--o.isBodyActive = false
				if t.hp <= 0 then
					destroyShip(t)
				end
				--o:removeSelf()
				--o = nil
			end, 1 )
		end
	end
end

-----------------------------------------------------------------------------------------
function impulseShip(t, dx, dy, speed)
	-- used in selectShip
	local length = math.sqrt(dx*dx + dy*dy)

    if length > 0 then
        local xI = dx / length;
        local yI = dy / length;

        if length > maxImpulseMoveSize then
        	length = maxImpulseMoveSize
        end
        local k = length / maxImpulseMoveSize * baseImpulse * t.res.speed

        if speed then
        	k = k * speed
        end

    	t:setLinearVelocity(xI*k, yI*k)
    	-- audio.play(soundEngine)
    end
end

-----------------------------------------------------------------------------------------
local arrows = {}
function selectShip( e )
	if isPause then return end

	local t = e.target
	local phase = e.phase

	local arrow = arrows[e.id]

	touchesPinch[ e.id ]  = nil

	if phase == 'began' then
		-- Shine overlay
		showInfo(t)
		--

		if e.target.enemy then return true end
		if e.target.name == "fighter" then return true end
		if e.target.name == "portal" then return true end
		if e.target.is_station then return true end
		--

		-- Stop ship
		t.targetPlanet = nil
		t.targetReached = false
		--

		-- Display line
		display.getCurrentStage():setFocus( t, e.id )
		t.isFocus = true
		-- print(t:getLinearVelocity())
        t:setLinearVelocity(0,0)

        arrows[e.id] = nil

        oneTouchBegan = true
    elseif t.isFocus then
    	local dx = e.x-e.xStart
	    local dy = e.y-e.yStart

		if arrow then
			arrow:removeSelf()
		end

		if "moved" == phase then
			-- TODO: draw arrow end
			-- TODO: limit arrow length
			-- TODO: fix target center
			-- local arrow = display.newLine(t.x,t.y, (e.x - group.x)/group.xScale, (e.y - group.y)/group.yScale )
			-- arrow.width = 3
			-- group:insert(arrow)
			-- arrows[e.id] = arrow

			t.rotation = - t.res.r + math.deg(math.atan2( -t.y + (e.y - group.y)/group.xScale, -t.x + (e.x - group.x)/group.yScale)) -- - t.imageRotation
			-- print(t.rotation)
		
		elseif "ended" == phase or "cancelled" == phase then
			oneTouchBegan = false

			-- arrows[e.id] = nil

			t.isFocus = false
			display.getCurrentStage():setFocus( t, e.id )
	    	
			impulseShip(t, dx, dy)
		end
	elseif "ended" == phase or "cancelled" == phase then
		oneTouchBegan = false
    end

    return true
end

-----------------------------------------------------------------------------------------
function targetShips(e)
	-- Autopilot ships to target planets

	if isPause then return end

	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if g.nameType == "ship" then
			if not g.inBattle and g.targetPlanet and not g.targetReached then
				-- ship auto-piloting to planet
				local planet = g.targetPlanet
				if not g.is_station then
					g.rotation = math.deg(math.atan2((planet.y - g.y), (planet.x - g.x)))
				end
				
				-- ship maybe near planet, inside of sensors physics body
				if (g.name ~="trade") and (math.abs(planet.x - g.x) < 2*planet.r) and (math.abs(planet.y - g.y) < 2*planet.r) then
					g.targetReached = true
					g:setLinearVelocity(0, 0)
				else
					local k = 1
					if g.name == "fighter" then
						k = 0.1
					end
					impulseShip(g, planet.x-g.x, planet.y-g.y, k)
				-- print(g.fullName.." go to planet "..g.targetPlanet.fullName)
				end
			end

			-- alien mothership
			-- build 2 fighters every 5 secs
			if g.name2 == "ms" and g.fighters < g.res.max_fighters then
				addAlienShip(g, 1)
				addAlienShip(g, 1)
				g.fighters = g.fighters + 2
			end
		end
	end
end

function repairCarrier()
	-- repair ships if it NOT in battle

	if isPause then return end

	-- local g = group.carrier

	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if g.nameType == "ship" and g.res.attack > 0 then
			if not g.inBattle then
				if g.shield < g.res.shield then
					g.shield = g.shield + 10
					if g.shield > g.res.shield then
						g.shield = g.res.shield
					end
				end

				if g.hp < g.res.hp then
					g.hp = g.hp + 1
				end

				if selectedObject == g then
					showInfo(g)
				end
			end
		end
	end
end