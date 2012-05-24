-----------------------------------------------------------------------------------------
--
-- discovery_detail.lua
--
-----------------------------------------------------------------------------------------

require "info"
require "game_ui"
require "notifications"

-----------------------------------------------------------------------------------------
function detailScreen()
	-- displays a detail of selected planet
	local item = selectedObject

	local p = display.newGroup()
	local dx, dy = 50, 50

	local dlg = display.newRoundedRect(50, 50, screenW-100, screenH-100, 10)
	dlg:setFillColor(0)
	dlg.alpha = 0.9
	p:insert(dlg)

	local infoTitle = display.newText(item.fullName, dx + 20, dy + 20, 300, 40, native.systemFont, 24)
	p:insert(infoTitle)

	local e = display.newImageRect("ships/"..item.name..".png", item.res.w, item.res.h)
	e.x, e.y = screenW-item.res.w, dy + item.res.h
	p:insert(e)

	local infoText = display.newText("Origin: Earth\n\n"..infoPedia[item.name], dx + 20, dy + 60, 600, 400, native.systemFont, 14)
	p:insert(infoText)

	infoText.text = infoText.text .. "\n\nStaff: "..item.res.staff.."\n\nHP: "..item.hp.."/"..item.res.hp.."\nShield: "..item.shield.."/"..item.res.shield.."\nAttack: "..item.res.attack.."\nWarp speed: "..item.res.speed.."\n\nLoad maximum: \nFighters: "..item.res.fighters_max.."\nRepair droids: "..item.res.droids_max

	local closeButton = display.newText("[ Close ]", screenW-200, screenH-120, 100, 40, native.systemFont, 24)
	p:insert(closeButton)
	closeButton:addEventListener('touch', function (e)
		if e.phase == 'ended' then
			gamePause(e)
			p:removeSelf()
		end

		return true
	end)
end