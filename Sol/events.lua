-----------------------------------------------------------------------------------------
--
-- events.lua
--
-----------------------------------------------------------------------------------------

require "info"
require "hud"


-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

-- Pinch to zoom Solar system
function OnZoomIn( event )
	if group.xScale < 3 then
		group.xScale = group.xScale * 1.01
		group.yScale = group.yScale * 1.01

		group.x = group.x * 1.01 + (screenW/2 - 1.01*screenW/2)
		group.y = group.y * 1.01 + (screenH/2 - 1.01*screenH/2)
	end
end

function OnZoomOut( event )
	if group.xScale > 0.2 then
		group.xScale = group.xScale / 1.01
		group.yScale = group.yScale / 1.01
		
		group.x = group.x / 1.01 + (screenW/2 - screenW/2.02)
		group.y = group.y / 1.01 + (screenH/2 - screenH/2.02)
	end
end

-----------------------------------------------------------------------------------------
function rotateSky( e )
	groupSky.rotation = groupSky.rotation - 0.05
end

-----------------------------------------------------------------------------------------
function hightlightSun( e )
	local s = display.newCircle(sun.x, sun.y, sun.r)
	-- local s = display.newImageRect("i/sun2.png", 350, 350)
	-- s.x, s.y = sun.x, sun.y

	local function removeHightligth( e )
		s:removeSelf()
	end

	s:setFillColor(200, 200, 0)
	s.alpha = 0.01
	group:insert(s)
	transition.to(s, {time=2000, alpha=0.3})
	transition.to(s, {delay=2000, time=2000, alpha=0.01, onComplete=removeHightligth})
end

-----------------------------------------------------------------------------------------
function movePlanets( e )
	-- Planets slowly fly on their eliptics orbits
	-- Moons fly around planets
	-- Ships targeted to planet and reached it fly around it too

	if isPause then return end

	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if (g.nameType == "planet") or (g.nameType == "asteroid") then
			g.alphaR = g.alphaR + 0.0002 * g.speed
			g.x = g.x0  + g.orbit * math.sin(g.alphaR)
			g.y = g.y0  + g.orbit/1.5 * math.cos(g.alphaR)
			-- print(g.name)
			-- print(g.x)
			-- print(g.y)
			-- move gravitation fields with their planets
			if g.field then
				g.field.x = g.x
				g.field.y = g.y
			end
			-- move overlay if planet selected
			if g.overlay then
				g.overlay.x = g.x
				g.overlay.y = g.y
			end

			-- move planet's moon if exists
			if g.moon then
				local moon = g.moon
				moon.x0, moon.y0 = g.x, g.y

				moon.alphaR = moon.alphaR + 0.001 * moon.speed
				moon.x = moon.x0  + moon.orbit * math.sin(moon.alphaR)
				moon.y = moon.y0  + moon.orbit/1.5 * math.cos(moon.alphaR)
				if moon.overlay then
					moon.overlay.x = moon.x
					moon.overlay.y = moon.y
				end
			end

			-- badges
			if g.badgeHuman then
				g.badgeHuman.x, g.badgeHuman.y = g.x + g.r, g.y - g.r
			end

			if g.badgeDefence then
				g.badgeDefence.x, g.badgeDefence.y = g.x + g.r + 30, g.y - g.r
			end

			if g.nameType == "asteroid" then
				g.rotation = g.rotation + 1
			end
		end
	end
end

-----------------------------------------------------------------------------------------
function moveAutopilot( e )
	-- SHIP ON PLANET
	-- Ships targeted to planet and reached it fly around it too

	if isPause then return end

	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if g.nameType == "ship" and g.targetPlanet and g.targetReached and not g.inBattle then
			local p = g.targetPlanet
			g.alphaR = g.alphaR + 0.001
			
			if g.is_station then
				g.rotation = 0

				g.x = p.x + g.orbit*p.r * math.sin(g.alphaR)
				g.y = p.y + g.orbit*p.r/1.5 * math.cos(g.alphaR)
			elseif g.enemy then
				g.rotation = math.deg(math.atan2((p.y - g.y), (p.x - g.x)))

				g.x = p.x + 1.2*g.orbit*p.r * math.sin(g.alphaR)
				g.y = p.y + 1.2*g.orbit*p.r/1.5 * math.cos(g.alphaR)
			elseif g.on_carrier then
				--
			else
				g.rotation = math.deg(-g.alphaR)
				g.x = p.x + g.orbit*p.r * math.sin(g.alphaR)
				g.y = p.y + g.orbit*p.r/1.5 * math.cos(g.alphaR)
			end
		end
	end
end

-----------------------------------------------------------------------------------------
function moveFighters( e )
	-- Move fighters near carrier

	if isPause then return end

	for i = 1, group.numChildren, 1 do
		local g = group[i]

		if g.on_carrier and not g.inBattle then
			local p = g.targetPlanet

			if not p then
				g.on_carrier = false
				g.targetPlanet = nil
				return true
			end

			g.alphaR = g.alphaR + 0.001

			local dx = -400 + math.random(800)
			local dy = -200 + math.random(400)

			if g.ship == "droid" then
				dx = -200 + math.random(400)
				dy = -100 + math.random(200)
			end

			g.rotation = p.rotation  --math.deg(math.atan2((p.y+dy - g.y), (p.x+dx - g.x)))
			-- g.rotation = math.deg(math.atan2((p.y+dy - g.y), (p.x+dx - g.x)))

			if math.sqrt((p.y-g.y)*(p.y-g.y)+(p.x-g.x)*(p.x-g.x)) > 200 then
				impulseShip(g, p.x-g.x, p.y-g.y, 0.2)
			else
				impulseShip(g, p.x+dx-g.x, p.y+dy-g.y, 0.05)
			end
		end
	end
end

-----------------------------------------------------------------------------------------
function selectPlanet( e )
	if isPause then return end

	local t = e.target

	touchesPinch[ e.id ]  = nil

	oneTouchBegan = true

	if e.phase == "ended" or e.phase == "cancelled" then
		oneTouchBegan = false

		if selectOverlay then
			selectOverlay:removeSelf()
			selectOverlay = nil
		end
		
		selectOverlay = display.newCircle(t.x, t.y, t.r)
		selectOverlay.alpha = 0.1
		selectOverlay.strokeWidth = 5
		selectOverlay:setStrokeColor(255)
		group:insert(selectOverlay)
		t.overlay = selectOverlay

		selectedObject = t

		showInfo(t)
	end

	return true
end

-----------------------------------------------------------------------------------------
function moveBg( e )
	if isPause then return end
	
	local sky = e.target

	if e.phase == "began" then
		local r = display.newCircle((e.x-group.x)/group.xScale, (e.y-group.y)/group.xScale, 30/group.xScale)
		r.alpha = 0.1
		group:insert(r)
		transition.to(r, {time=200, alpha=0.5})
		transition.to(r, {delay=200, time=200, alpha=0, onComplete=function ()
			r:removeSelf()
		end})

		oneTouchBegan = true

		if selectOverlay then
			selectOverlay:removeSelf()
			selectOverlay = nil
		end
		selectedObject = nil
		showInfo(nil)

		--groupHud.alpha = 0
		groupX, groupY = group.x, group.y
		sky.x0, sky.y0 = sky.x, sky.y
	elseif e.phase == "moved" then
		if oneTouchBegan then
			group.x = groupX + (e.x - e.xStart)
			group.y = groupY + (e.y - e.yStart)
			
			-- groupSky.sky.x = sky.x0 + (e.x - e.xStart) / 20
			-- groupSky.sky.y = sky.y0 + (e.y - e.yStart) / 20

			sky.x = sky.x0 + (e.x - e.xStart) / 5
			sky.y = sky.y0 + (e.y - e.yStart) / 10

			if (sky.x > sky.width/2) then
				sky.x = sky.width/2
			end
			if (sky.x < screenW-sky.width/2) then
				sky.x = screenW-sky.width/2
			end
			if (sky.y > sky.height/2) then
				sky.y = sky.height/2
			end
			if (sky.y < screenH-sky.height/2) then
				sky.y = screenH-sky.height/2
			end
		end
	elseif e.phase == "ended" or e.phase == "cancelled" then
		groupX, groupY = 0, 0
		oneTouchBegan = false
	end

	return true
end

-----------------------------------------------------------------------------------------
function frameHandler( e )
	local s = selectedObject
	local border = 300 -- keep moving ship inside this
	local delta = 1
	local fast = 5

	if isPause then return end

	if s then
		if s.nameType == "ship" and s.alpha == 0 then
			-- remove alpha 0 defeated battleships
			s:removeSelf()
			s = nil
		end
	end
end
