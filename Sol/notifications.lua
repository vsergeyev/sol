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
	baloonGroup.alpha = 0.7

	local b = display.newRoundedRect(0, 0, 200, 95, 5)
	b.strokeWidth = 3
	b:setFillColor(0)
	b:setStrokeColor(0, 200, 100)
	baloonGroup:insert(b)

	local t = display.newText(text, 10, 10, 180, 76, native.systemFont, 16)
	t:setTextColor(0, 200, 100)
	baloonGroup:insert(t)

	baloonGroup.x, baloonGroup.y = screenW-203, screenH-190
	groupNotifications.baloon = baloonGroup
	groupNotifications:insert(baloonGroup)

	transition.to(baloonGroup,{delay=3000, time=2000, alpha=0})
end

-----------------------------------------------------------------------------------------
function showHint(text, x, y)
	-- display popup hint

	local baloonGroup = display.newGroup()
	baloonGroup.alpha = 0.1

	local b = display.newRoundedRect(0, 0, 200, 95, 5)
	b.strokeWidth = 3
	b:setFillColor(0)
	b:setStrokeColor(0, 200, 100)
	baloonGroup:insert(b)

	local t = display.newText(text, 10, 10, 180, 76, native.systemFont, 16)
	t:setTextColor(0, 200, 100)
	baloonGroup:insert(t)

	baloonGroup.x, baloonGroup.y = x, y
	groupNotifications:insert(baloonGroup)

	transition.to(baloonGroup,{delay=1000, time=2000, alpha=0.7})
	
	return baloonGroup
end
