-----------------------------------------------------------------------------------------
--
-- events.lua
--
-----------------------------------------------------------------------------------------

require "info"
require "hud"

local selectOverlay = nil

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
	for i = 1, group.numChildren, 1 do
		local g = group[i]
		if g.nameType == "planet" then
			g.alphaR = g.alphaR + 0.001 * g.speed
			g.x = g.x0  + g.orbit * math.sin(g.alphaR)
			g.y = g.y0  + g.orbit/1.5 * math.cos(g.alphaR)
			if g.overlay then
				g.overlay.x = g.x
				g.overlay.y = g.y
			end
		end
	end
end

-----------------------------------------------------------------------------------------
function selectPlanet( e )
	local t = e.target

	if selectOverlay then
		selectOverlay:removeSelf()
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

-----------------------------------------------------------------------------------------
function addHud()
	local infoPanel = display.newRect(0, 0, 200, screenH)
	infoPanel:setFillColor( 127 )

	local infoTitle = display.newText("", 10, 10, 180, 20, native.systemFont, 16)
	local infoText = display.newText("", 10, 40, 180, 300, native.systemFont, 12)

	local buildPanel = display.newRect(10, screenH-300, 180, 250)
	buildPanel:setFillColor(127)
	buildPanel.strokeWidth = 1
	buildPanel:setStrokeColor(100)
	
	-- Build buttons
	local buildShip = display.newImageRect("ui/build/ship.png", 70, 70)
	buildShip:setReferencePoint(display.TopLeftReferencePoint)
	buildShip.x, buildShip.y = 10, screenH-300
	buildShip.name = "button"
	buildShip.nameType = "build"
	buildShip:addEventListener('touch', hudBuildShip)
	buildPanel.ship = buildShip

	-- Resources
	local infoMoney = display.newText("", 10, screenH-30, 180, 20, native.systemFont, 16)
	infoMoney:setTextColor(200, 200, 80)

	groupHud:insert(infoPanel)
	groupHud:insert(infoTitle)
	groupHud:insert(infoText)
	groupHud:insert(buildPanel)
	groupHud:insert(buildShip)
	groupHud:insert(infoMoney)

	groupHud.x = screenW-200
	groupHud.title = infoTitle
	groupHud.text = infoText
	groupHud.build = buildPanel
	groupHud.money = infoMoney
	groupHud.alpha = 0
end

-----------------------------------------------------------------------------------------
function moveBg( e )
	if e.phase == "began" then
		groupX, groupY = group.x, group.y
	elseif e.phase == "moved" then
		group.x = groupX + (e.x - e.xStart)
		group.y = groupY + (e.y - e.yStart)
	elseif e.phase == "ended" or e.phase == "cancelled" then
		groupX, groupY = 0, 0
	end

	return true
end
