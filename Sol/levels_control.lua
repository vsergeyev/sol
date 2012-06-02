-----------------------------------------------------------------------------------------
--
-- levels_control.lua
--
-----------------------------------------------------------------------------------------

require "aliens"

-----------------------------------------------------------------------------------------

levelsData = {
	{
		title = "Mission 1: Ticket To The Moon",
		task = [[Establish colony on the Moon.

Build USS "E.C.S." class ship and use it to colonize Earth's satelite.

Once colony established, build USS "Minecrafter" class space ships to transport rare minerals from the Moon to Earth and equipment & supplies back to colonists.

Victory condition: gain 200 MC]],
		goal = 200, -- resources, victory condition
		sound = "level1.m4a"
	},
	{
		title = "Mission 2: Be My Baby",
		task = [[Good to go, Admiral,

Our colonists work hard on the Moon to supply our fleet with rare minerals. We should protect them from any treat from outer space.

Build Defence Starbase on the orbit of the Moon. Our starbases come with heavy fazer guns and protective shields. It is best in terms of "cost-value" solution for defending planets and satelites.

Victory condition: Defence Starbase + 2 fighters.
]],
		base = true,
		fighters = 2
	},
	{
		title = "Mission 3: First Contact",
		task = [[Admiral, today is great day for all Humanity,

We have received incoming signatures. Scanners shows objects, very similar to space crafts and they approaching to our planet.

Prepare fleets to meet our new friends and escort their ships safely to the Earth.

Victory condition: meet alien fleet]],
		spawn = {
			aliens = 5
		},
		destroy_fighters = true
	},
	{
		title = "Mission 4: First Contact War",
		task = [[Admiral, our new "friends" show themselfs not so friendly.

The High Command ordered us to expand our military presence in Solar System. Build USS "Discovery" class carrier and escort colonists ships to Mercury and Venus.

USS "Discovery" class warships designed to bring our fighters in the heart of battle. Those massive spacecrafts carry heavy fazers artillery and powerful shield generators. Every carrier has repair droids and can fix most of damages while out of battle.

Victory condition: USS "Discovery" carrier + colony on Mercury and Venus.]],
		spawn = {
			aliens = 20,
			frigates = 2,
			times = 10
		}
	},
}

-----------------------------------------------------------------------------------------
function levelScreen(item)
	-- displays a detail of Level task

	-- pause game
	isPause = true
	physics.pause()

	-- dialog
	local p = display.newGroup()
	local dx, dy = 150, 150

	local dlg = display.newRoundedRect(100, 100, screenW-200, screenH-200, 10)
	dlg:setFillColor(0)
	dlg.alpha = 0.9
	p:insert(dlg)

	local infoTitle = display.newText(item.title, dx + 20, dy + 20, 600, 40, native.systemFont, 24)
	infoTitle:setTextColor(0, 200, 100)
	p:insert(infoTitle)

	local infoText = display.newText(item.task, dx + 20, dy + 100, 600, 400, native.systemFont, 18)
	infoText:setTextColor(0, 200, 100)
	p:insert(infoText)

	local closeButton = display.newText("[ Start mission ]", screenW-350, screenH-200, 200, 40, native.systemFont, 24)
	closeButton:setTextColor(0, 200, 100)
	p:insert(closeButton)
	closeButton:addEventListener('touch', function (e)
		if e.phase == 'ended' then
			gamePause(e)
			p:removeSelf()
			if item.sound then
				local sound = audio.loadStream("sounds/"..item.sound)
				audio.play(sound)
			end
		end

		return true
	end)
end

-----------------------------------------------------------------------------------------
function victoryScreen(item)
	-- VICTORY in level

	-- pause game
	isPause = true
	physics.pause()

	-- dialog
	local p = display.newGroup()
	local dx, dy = 150, 150

	local dlg = display.newRoundedRect(100, 100, screenW-200, screenH-200, 10)
	dlg:setFillColor(0)
	dlg.alpha = 0.9
	p:insert(dlg)

	local infoTitle = display.newText("Victory!", dx + 20, dy + 20, 600, 40, native.systemFont, 24)
	infoTitle:setTextColor(0, 200, 100)
	p:insert(infoTitle)

	local infoText = display.newText(item.title, dx + 20, dy + 100, 600, 400, native.systemFont, 18)
	infoText:setTextColor(0, 200, 100)
	p:insert(infoText)

	local closeButton = display.newText("[ Next mission ]", screenW-350, screenH-200, 200, 40, native.systemFont, 24)
	closeButton:setTextColor(0, 200, 100)
	p:insert(closeButton)
	closeButton:addEventListener('touch', function (e)
		if e.phase == 'ended' then
			gamePause(e)
			p:removeSelf()
			levelNow = levelNow + 1
			startLevel(levelNow)
		end

		return true
	end)
end

-----------------------------------------------------------------------------------------
local function spawnAliens(e)
	if isPause then return true end

	local l = levelsData[levelNow]

	for i=1, l.spawn.aliens, 1 do
		addAlienShip()
	end

	if l.spawn.frigates then
		for i=1, l.spawn.frigates, 1 do
			addAlienShip(nil, 2)
		end
	end
end

-----------------------------------------------------------------------------------------
function startLevel(level)
	local l = levelsData[level]
	
	-- spawn enemies
	if l.spawn then
		if l.spawn.aliens then
			if l.spawn.times then
				timer.performWithDelay(30000, spawnAliens, 0 )
			else
				for i=1, l.spawn.aliens, 1 do
					addAlienShip(group.earth)
				end
			end
		end
	end

	levelScreen(l)
end

-----------------------------------------------------------------------------------------
function levelCondition(e)
	if isPause then return true end

	local l = levelsData[levelNow]

	if l.goal and l.goal <= gold then
		-- victory
		victoryScreen(l)
	elseif l.base and l.fighters then
		local has_base, num_fighters = false, 0

		for i = 1, group.numChildren, 1 do
			local g = group[i]
			if g.name == "station" then
				has_base = true
			elseif g.name == "fighter" and not g.enemy then
				num_fighters = num_fighters + 1
			end
		end

		if has_base and num_fighters >= l.fighters then
			victoryScreen(l)
		end
	elseif l.destroy_fighters then
		local num_fighters = 0
		for i = 1, group.numChildren, 1 do
			local g = group[i]
			if g.name2 == "fighter" and g.enemy then
				num_fighters = num_fighters + 1
			end
		end

		if num_fighters == 0 then
			victoryScreen(l)
		end
	end
end