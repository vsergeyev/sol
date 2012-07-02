-----------------------------------------------------------------------------------------
--
-- dialogs.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require "storyboard"

-----------------------------------------------------------------------------------------
function addButton(text, x, y, fun, gr)
	local p = group
	if gr then
		p = gr
	end

	local cButton = display.newText(text, x, y, 220, 48, native.systemFont, 32)
	cButton:setTextColor(0, 156, 73)
	p:insert(cButton)

	local btn = display.newImageRect("ui/buttons/btn.png", 300, 60)
	btn:setReferencePoint(display.TopLeftReferencePoint)
	btn.x, btn.y = x-50, y-7
	btn.text = cButton
	p:insert(btn)

	btn:addEventListener('touch', function (e)
		if e.phase == "began" then
			e.target.alpha = 0.5
			e.target.text.alpha = 0.5
		elseif e.phase == "ended" then
			e.target.alpha = 1
			e.target.text.alpha = 1
			fun(e)
		end
		return true
	end)

	return btn --cButton
end

-----------------------------------------------------------------------------------------
function showPauseDlg(e)
	local p = display.newGroup()
	local dx, dy = 10, 10

	local dlg = display.newRect(0, 0, screenW, screenH)
	dlg:setFillColor(0)
	dlg.alpha = 0.9
	p:insert(dlg)

	local bg = display.newImage("bg/bg2.png")
	p:insert(bg)
	local bg = display.newImage("ui/victory.png")
	p:insert(bg)

	local infoTitle = nil
	if levelNow then
		infoTitle = display.newText("Paused", dx + 20, dy + 20, 600, 40, native.systemFont, 24)		

		local infoText = display.newText(levelsData[levelNow].task, dx + 20, dy + 100, 600, 400, native.systemFont, 18)
		infoText:setTextColor(0, 200, 100)
		p:insert(infoText)
	else
		infoTitle = display.newText("Paused", 400, dy + 160, 400, 200, native.systemFont, 48)
	end

	infoTitle:setTextColor(0, 200, 100)
	p:insert(infoTitle)

	local menuButton = addButton("Exit to menu", screenW-570, screenH-70, function (e)
		p:removeSelf()
		gameMenu(e)
	end, p)

	local closeButton = addButton("Resume", screenW-270, screenH-70, function (e)
		p:removeSelf()
		gamePause(e)
	end, p)
end

-----------------------------------------------------------------------------------------
function showSurvivalDlg(e, text, isVictory)
	-- Mission/VICTORY in Survival mode

	-- pause game
	isPause = true
	physics.pause()

	local p = display.newGroup()
	local dx, dy = 10, 10

	local dlg = display.newRect(0, 0, screenW, screenH)
	dlg:setFillColor(0)
	dlg.alpha = 0.9
	p:insert(dlg)

	local bg = display.newImage("bg/bg2.png")
	p:insert(bg)
	local bg = display.newImage("ui/planet.png")
	p:insert(bg)

	local infoTitle = display.newText("Survival mode", dx + 20, dy + 20, 600, 40, native.systemFont, 24)
	infoTitle:setTextColor(0, 200, 100)
	p:insert(infoTitle)

	local infoText = nil
	if isVictory then
		infoText = display.newText(text, 400, 200, 400, 200, native.systemFont, 48)
	else
		infoText = display.newText(text, dx + 20, dy + 100, 600, 300, native.systemFont, 18)
	end
	infoText:setTextColor(0, 200, 100)
	p:insert(infoText)

	if isVictory then
		local menuButton = addButton("Exit to menu", screenW-570, screenH-70, function (e)
			p:removeSelf()
			gameMenu(e)
		end, p)
	end

	local closeButton = addButton("Resume", screenW-270, screenH-70, function (e)
		p:removeSelf()
		gamePause(e)
	end, p)
end

-----------------------------------------------------------------------------------------
function showSurvivalVictoryDlg(e)
	-- Mission/VICTORY in Survival mode

	-- pause game
	isPause = true
	physics.pause()

	local p = display.newGroup()
	local dx, dy = 10, 10

	local dlg = display.newRect(0, 0, screenW, screenH)
	dlg:setFillColor(0)
	dlg.alpha = 0.9
	p:insert(dlg)

	local bg = display.newImage("bg/bg2.png")
	p:insert(bg)
	local bg = display.newImage("ui/planet.png")
	p:insert(bg)
	local bg = display.newImage("ui/text_victory.png")
	bg.x, bg.y = screenW/2, 80
	p:insert(bg)

	local infoTitle = display.newText("Survival mode", 30, 200, 600, 40, native.systemFont, 24)
	infoTitle:setTextColor(0, 200, 100)
	p:insert(infoTitle)

	local infoText = display.newText(gameStat.money.." MC earned\n"..gameStat.ships.." ships built\n"..gameStat.killed.." enemies killed", 30, 260, 600, 400, native.systemFont, 18)
	infoText:setTextColor(0, 200, 100)
	p:insert(infoText)

	local menuButton = addButton("Exit to menu", screenW-270, screenH-70, function (e)
		p:removeSelf()
		gameMenu(e)
	end, p)
end
