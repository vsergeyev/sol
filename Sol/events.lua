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
	local k = 1.007
	if group.xScale < 3 then
		group.xScale = group.xScale * k
		group.yScale = group.yScale * k

		group.x = group.x * k + (screenW/2 - k*screenW/2)
		group.y = group.y * k + (screenH/2 - k*screenH/2)
	end
end

function OnZoomOut( event )
	local k = 1.007
	if group.xScale > 0.2 then
		group.xScale = group.xScale / k
		group.yScale = group.yScale / k
		
		group.x = group.x / k + (screenW/2 - screenW/(2*k))
		group.y = group.y / k + (screenH/2 - screenH/(2*k))
	end
end

-----------------------------------------------------------------------------------------
function createOverlay( t, r )
	if selectOverlay then
		selectOverlay.alpha = 1
		return true
	end
	selectOverlay = display.newImageRect("i/selection.png", r*3, r*3)
	selectOverlay.x, selectOverlay.y = t.x, t.y
	group:insert(selectOverlay)
	t.overlay = selectOverlay
end

-----------------------------------------------------------------------------------------
function rotateSky( e )
	groupSky.rotation = groupSky.rotation - 0.05
end

-----------------------------------------------------------------------------------------
function hightlightSun( e )
	local s = display.newCircle(sun.x, sun.y, sun.r)

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

	for i = 1, #group.planets, 1 do
		local g = group.planets[i]
		if (g.nameType == "planet") or (g.nameType == "asteroid") then
			g.alphaR = g.alphaR + 0.0002 * g.speed
			g.x = g.x0  + g.orbit * math.sin(g.alphaR)
			g.y = g.y0  + g.orbit/1.5 * math.cos(g.alphaR)

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
				if moon.field then
					moon.field.x = moon.x
					moon.field.y = moon.y
				end
				if moon.overlay then
					moon.overlay.x = moon.x
					moon.overlay.y = moon.y
				end
				if moon.badgeHuman then
					moon.badgeHuman.x, moon.badgeHuman.y = moon.x + moon.r, moon.y - moon.r
				end
			end

			-- badges
			if g.badgeHuman then
				g.badgeHuman.x, g.badgeHuman.y = g.x + g.r, g.y - g.r
			end

			if g.nameType == "asteroid" then
				g.rotation = g.rotation + 1
			end
		end
	end
end

-----------------------------------------------------------------------------------------
function moveAutopilot( e )
	-- SHIP ON PLANET/STATION/CARRIER
	-- Ships targeted to planet and reached it fly around it too

	if isPause then return end

	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if g.nameType == "ship" and g.targetPlanet and g.targetReached and not g.inBattle then
			local p = g.targetPlanet
			if g.name == "fighter" or g.name2 == "fighter" then
				g.alphaR = g.alphaR + 0.1
			else
				g.alphaR = g.alphaR + 0.005
			end

			--if not g.on_carrier then
				if g.is_station then
					g.rotation = 0
				elseif g.enemy and p.res.colonized then
					g.rotation = math.deg(math.atan2((p.y - g.y), (p.x - g.x)))
					timer.performWithDelay(math.random(200), function()
						attackPlanetAI(g, p)
					end, 1)
				else
					g.rotation = math.deg(-g.alphaR)
				end
				-- g.x = p.x + g.orbit*p.r * math.sin(g.alphaR)
				-- g.y = p.y + g.orbit*p.r/1.5 * math.cos(g.alphaR)
				x2 = p.x + 1.5*g.orbit*p.r * math.sin(g.alphaR)
				y2 = p.y + g.orbit*p.r * math.cos(g.alphaR)

				local k = 0.8 + math.random(10) / 20
				if g.name == "fighter" then
					k = 1 -- + math.random(10) / 20
				end
				if g.name2 == "fighter" then
					k = 0.5
				end
				impulseShip(g, x2-g.x, y2-g.y, k)
			--end
		end
	end
end

-----------------------------------------------------------------------------------------
function selectPlanet( e )
	if isPause then return end

	local t = e.target

	touchesPinch[ e.id ]  = nil

	if e.phase == "ended" or e.phase == "cancelled" then

		if selectOverlay then
			selectOverlay:removeSelf()
			selectOverlay = nil
		end
		
		createOverlay(t, t.r)
		selectedObject = t

		showInfo(t)
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

	if selectOverlay and selectOverlay.alpha > 0 then
		selectOverlay.rotation = selectOverlay.rotation + 1
	end

	if s then
		if s.nameType == "ship" then
			if s.alpha == 0 then
				-- remove alpha 0 defeated battleships
				s:removeSelf()
				s = nil
			elseif selectOverlay and selectOverlay.ship then
				selectOverlay.x, selectOverlay.y = s.x, s.y
			end
		end
	end
end
