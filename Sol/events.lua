-----------------------------------------------------------------------------------------
--
-- events.lua
--
-----------------------------------------------------------------------------------------

require "info"
require "hud"


local oneTouchBegan = false

-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

-- Pinch to zoom Solar system
function OnZoomIn( event )
	if group.xScale < 3 then
		group.xScale = group.xScale * 1.01
		group.yScale = group.yScale * 1.01
	end
end

function OnZoomOut( event )
	if group.xScale > 0.3 then
		group.xScale = group.xScale / 1.01
		group.yScale = group.yScale / 1.01
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

	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if g.nameType == "planet" then
			g.alphaR = g.alphaR + 0.0002 * g.speed
			g.x = g.x0  + g.orbit * math.sin(g.alphaR)
			g.y = g.y0  + g.orbit/1.5 * math.cos(g.alphaR)
			-- move gravitation fields with their planets
			g.field.x = g.x
			g.field.y = g.y
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
			if g.badgeDefence then
				g.badgeDefence.x, g.badgeDefence.y = g.x + g.r, g.y - g.r
			end
		elseif g.nameType == "ship" and g.targetPlanet and g.targetReached then
			local p = g.targetPlanet
			if not g.alphaR then
				g.alphaR = 0
			end
			g.alphaR = g.alphaR + 0.01
			g.rotation = math.deg(-g.alphaR)
			g.x = p.x  + g.orbit*p.r * math.sin(g.alphaR)
			g.y = p.y  + g.orbit*p.r/1.5 * math.cos(g.alphaR)
		end
	end
end

-----------------------------------------------------------------------------------------
function selectPlanet( e )
	local t = e.target

	if e.phase == "ended" then
		if selectOverlay then
			selectOverlay:removeSelf()
			selectOverlay = nil
		end
		
		selectOverlay = display.newCircle(t.x, t.y, t.r)
		selectOverlay.alpha = 0.3
		selectOverlay.strokeWidth = 5
		selectOverlay:setStrokeColor(255)
		group:insert(selectOverlay)
		t.overlay = selectOverlay

		selectedObject = t

		showInfo(t)
	end
end

-----------------------------------------------------------------------------------------
function moveBg( e )
	local sky = e.target

	if e.phase == "began" then
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
			
			groupSky.sky.x = sky.x0 + (e.x - e.xStart) / 30
			groupSky.sky.y = sky.y0 + (e.y - e.yStart) / 30
			sky.x = sky.x0 + (e.x - e.xStart) / 100
			sky.y = sky.y0 + (e.y - e.yStart) / 100
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

	if s then
		-- keep moving ship in bounds of screen
		-- move screen instead
		if false and s.nameType == "ship" then
			if s.x + group.x < border then
				group.x = group.x + delta
			end
			if s.x + group.x < border/2 then
				group.x = group.x + fast*delta
			end

			if s.x + group.x > screenW - border then
				group.x = group.x - delta
			end
			if s.x + group.x > screenW - border/2 then
				group.x = group.x - fast*delta
			end

			if s.y + group.y < border then
				group.y = group.y + delta
			end
			if s.y + group.y < border/2 then
				group.y = group.y + fast*delta
			end

			if s.y + group.y > screenH - border then
				group.y = group.y - delta
			end
			if s.y + group.y > screenH - border/2 then
				group.y = group.y - fast*delta
			end
		end
	end
end
