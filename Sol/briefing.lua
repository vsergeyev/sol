-----------------------------------------------------------------------------------------
--
-- briefing.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require "storyboard"

require("dialogs")
-- require("levels_control")

-----------------------------------------------------------------------------------------
function showBriefing()
	-- pause game
	isPause = true
	physics.pause()
	
	
	local p = display.newGroup()
	local l = levelsData[levelNow]

	local dlg = display.newRect(0, 0, screenW, screenH)
	dlg:setFillColor(0)
	p:insert(dlg)

	local bg = display.newImage("bg/bg2.png")
	p:insert(bg)

	local gr = display.newImageRect("i/atmosphere.png", 350, 350)
	gr.x, gr.y = screenW/2, screenH/2
	p:insert(gr)

	local planet = display.newImageRect("i/"..l.planet..".png", 300, 300)
	planet.x, planet.y = screenW/2, screenH/2
	p:insert(planet)

	local infoText = display.newText(l.task, 30, screenH-100, 600, 400, native.systemFont, 18)
	infoText:setTextColor(0, 200, 100)
	p:insert(infoText)
	local tmr = timer.performWithDelay(50, function (e)
		if not infoText["y"] then
			timer.cancel( e.source )
			tmr = nil
			return true
		end
		if infoText.y > 400 then
			infoText.y = infoText.y-2
		else
			timer.cancel( e.source )
			tmr = nil
		end
	end, 0 )

	local dlg = display.newRect(0, screenH-100, screenW, 100)
	dlg:setFillColor(0)
	dlg.alpha = 1
	p:insert(dlg)

	local infoTitle = display.newText(l.title, 30, 30, 600, 40, native.systemFont, 36)
	infoTitle:setTextColor(0, 200, 100)
	p:insert(infoTitle)

	local menuButton = addButton("Exit to menu", screenW-570, screenH-70, function (e)
		timer.cancel(tmr)
		tmr = nil
		p:removeSelf()
		gameMenu(e)
	end, p)

	local closeButton = addButton("Start", screenW-270, screenH-70, function (e)
		p:removeSelf()
		gamePause(e)
	end, p)
end

-----------------------------------------------------------------------------------------

-- showBriefing()
