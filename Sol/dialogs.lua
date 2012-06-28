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

	local cButton = display.newText(text, x, y, 220, 45, native.systemFont, 36)
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
	local dx, dy = 150, 150

	local dlg = display.newRoundedRect(100, 100, screenW-200, screenH-200, 10)
	dlg:setFillColor(0)
	dlg.alpha = 0.9
	p:insert(dlg)

	local ea = display.newImageRect("ui/alliance.png", 100, 101)
	ea.x, ea.y = screenW-200, dy + 50
	p:insert(ea)

	local infoTitle = nil
	if levelNow then
		infoTitle = display.newText("Paused", dx + 20, dy + 20, 600, 40, native.systemFont, 24)		

		local infoText = display.newText(levelsData[levelNow].task, dx + 20, dy + 100, 600, 400, native.systemFont, 18)
		infoText:setTextColor(0, 200, 100)
		p:insert(infoText)
	else
		infoTitle = display.newText("Paused", dx + 250, dy + 160, 400, 200, native.systemFont, 48)
	end

	infoTitle:setTextColor(0, 200, 100)
	p:insert(infoTitle)

	local menuButton = addButton("Exit to menu", screenW-660, screenH-200, function (e)
		p:removeSelf()
		gameMenu(e)
	end, p)

	local closeButton = addButton("Resume", screenW-360, screenH-200, function (e)
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
	local dx, dy = 150, 150

	local dlg = display.newRoundedRect(100, 100, screenW-200, screenH-200, 10)
	dlg:setFillColor(0)
	dlg.alpha = 0.9
	p:insert(dlg)

	local ea = display.newImageRect("ui/alliance.png", 100, 101)
	ea.x, ea.y = screenW-200, dy + 50
	p:insert(ea)

	local infoTitle = display.newText("Survival mode", dx + 20, dy + 20, 600, 40, native.systemFont, 24)
	infoTitle:setTextColor(0, 200, 100)
	p:insert(infoTitle)

	local infoText = nil
	if isVictory then
		infoText = display.newText(text, dx + 250, dy + 200, 400, 200, native.systemFont, 48)
	else
		infoText = display.newText(text, dx + 20, dy + 100, 600, 300, native.systemFont, 18)
	end
	infoText:setTextColor(0, 200, 100)
	p:insert(infoText)

	if isVictory then
		local menuButton = addButton("Exit to menu", screenW-660, screenH-200, function (e)
			p:removeSelf()
			gameMenu(e)
		end, p)
	end

	local closeButton = addButton("Resume", screenW-360, screenH-200, function (e)
		p:removeSelf()
		gamePause(e)
	end, p)
end
