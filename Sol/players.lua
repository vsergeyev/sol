-----------------------------------------------------------------------------------------
--
-- players.lua
--
-----------------------------------------------------------------------------------------

function addPlayers()
	-- Scores
	local label1 = display.newText( "White Amoeba: 0", 200, 12, native.systemFont, 26)
	label1:setReferencePoint( display.TopLeftReferencePoint )
	label1.x, label1.y = 0, 0
	label1.prefix = "White Amoeba: "
	label1:setTextColor(200)
	group:insert( label1 )

	local label2 = display.newText( "Blue Amoeba: 0", 200, 12, native.systemFont, 26)
	label2:setReferencePoint( display.BottomRightReferencePoint )
	label2.x, label2.y = screenW-50, screenH
	label2.prefix = "Blue Amoeba: "
	label2:setTextColor(80, 80, 250)
	group:insert( label2 )


	-- Players
	local c0 = movieclip.newAnim({"i/ameba.png", "i/ameba2.png"})
	c0:setSpeed(.1)
	c0:play()
	c0.x, c0.y = screenW/2, 50
	c0.name = "player"
	c0.score = 0
	c0.label = label1
	-- c0:setFillColor(50, 50, 200)
	physics.addBody( c0, {bounce=0.5, friction=0.5, radius=40} )
	group:insert(c0)
	c0:addEventListener('touch', moveAmeba)
	-- c0.isFixedRotation = true
	c0.collision = collisionAmeba
	c0:addEventListener( "collision",  c0)


	local c1 = movieclip.newAnim({"i/ameba-blue.png", "i/ameba-blue2.png"})
	c1:setSpeed(.1)
	c1:play()
	c1.x, c1.y = screenW/2, screenH-50
	c1.name = "player"
	c1.score = 0
	c1.label = label2
	physics.addBody( c1, {bounce=0.5, friction=0.5, radius=40} )
	group:insert(c1)
	c1:addEventListener('touch', moveAmeba)
	c1.collision = collisionAmeba
	c1:addEventListener( "collision",  c1)
end

---------------------------------------
function addWalls()
	-- Walls
	local topWall = display.newRect(-50, -50, screenW+100, 1)
	local bottomWall = display.newRect(-50, screenH+50, screenW+100, 1)
	local leftWall = display.newRect(-50, -50, 1, screenH+100)
	local rightWall = display.newRect(screenW+50, -50, 1, screenH+100)
	physics.addBody( topWall, 'static', {bounce=0} )
	physics.addBody( bottomWall, 'static', {bounce=0} )
	physics.addBody( leftWall, 'static', {bounce=0} )
	physics.addBody( rightWall, 'static', {bounce=0} )
end