-----------------------------------------------------------------------------------------
--
-- notifications.lua
--
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------
function showBaloon(text)
	-- display popup at right bottom corner

	if groupNotifications.baloon then
		groupNotifications.baloon:removeSelf()
	end

	local baloonGroup = display.newGroup()
	baloonGroup.alpha = 0.5

	local b = display.newRoundedRect(0, 0, 200, 95, 5)
	b.strokeWidth = 3
	b:setFillColor(140, 140, 140)
	b:setStrokeColor(180, 180, 180)
	baloonGroup:insert(b)

	local t = display.newText(text, 10, 10, 180, 75, native.systemFont, 16)
	baloonGroup:insert(t)

	baloonGroup.x, baloonGroup.y = screenW-200, screenH-300
	groupNotifications.baloon = baloonGroup
	groupNotifications:insert(baloonGroup)

	transition.to(baloonGroup,{delay=3000, time=2000, alpha=0})
end
