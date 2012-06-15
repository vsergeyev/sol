-----------------------------------------------------------------------------------------
--
-- levels_control.lua
--
-----------------------------------------------------------------------------------------

require "aliens"

local initialSpawn = false

-----------------------------------------------------------------------------------------

levelsData = {
-- MISSION 1
	{
		title = "Mission 1: Ticket To The Moon",
		task = [[Establish colony on the Moon.

Build USS "E.C.S." class ship and use it to colonize Earth's satelite.

Once colony established, build USS "Minecrafter" class space ships to transport rare minerals from the Moon to Earth and equipment & supplies back to colonists.

Victory condition: gain 200 MC]],
		goal = 200, -- resources, victory condition
		sound = "level1.m4a"
	},

-- MISSION 2
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

-- MISSION 3
	{
		title = "Mission 3: First Contact",
		task = [[Admiral, today is great day for all Humanity,

We have received incoming signatures. Scanners shows objects, similar to space crafts and they approaching to our planet. We are about to establish contact with alien civilization.

From other hand we don't know their goals. Prepare our battle ships to meet incoming fleet and stay alerted.

[Moon outpost]: They don't responding to our welcome transmissions. Oh shi....]],
		spawn = {
			aliens = 5,
			times = 1,
			delay = 0,
			target = "earth"
		},
		destroy_fighters = true
	},

-- MISSION 4
	{
		title = "Mission 4: First Contact War",
		task = [[Admiral, our new "friends" show themselfs not so friendly.

The High Command ordered us to expand our military presence in Solar System. Build USS "Discovery" class carrier and escort colonists ships to Mercury and Venus.

USS "Discovery" class warships designed to bring our fighters in the heart of battle. Those massive spacecrafts carry heavy fazers artillery and powerful shield generators. Every carrier has repair droids and can fix most of damages while out of battle.

Victory condition: USS "Discovery" carrier + colony on Mercury and Venus.]],
		spawn = {
			aliens = 20,
			frigates = 2,
			times = 10,
			delay = 30000
		},
		colonize_all = true
	},

-- MISSION 5
	{
		title = "Mission 5: Protect Earth",
		task = [[Admiral, our sensors detected big alien vessel approaching to Earth.

Our experts believe it is some sort of mothership. This spacecraft has size bigger than Manhattan. Imagine how powerful weapons it can carry.

Stop this mothership at any cost, Admiral.
We will pray for you, good luck!

Victory condition: Earth must be saved.]],
		spawn = {
			aliens = 20,
			frigates = 4,
			ms = 1,
			times = 1,
			delay = 1000
		},
		destroy_ms = true
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

	local ea = display.newImageRect("/ui/alliance.png", 100, 101)
	ea.x, ea.y = screenW-200, dy + 50
	p:insert(ea)

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
	if isPause and not initialSpawn then return true end

	initialSpawn = false

	local l = levelsData[levelNow]
	local target = nil

	if l.spawn.target == "earth" then
		target = group.earth
	end

	-- spawn fighter
	for i=1, l.spawn.aliens, 1 do
		addAlienShip(target, 1)
	end

	-- spawn frigate
	if l.spawn.frigates then
		for i=1, l.spawn.frigates, 1 do
			addAlienShip(target, 2)
		end
	end

	-- spawn mothership
	if l.spawn.ms then
		for i=1, l.spawn.ms, 1 do
			addAlienShip(group.earth, 4)
		end
	end
end

-----------------------------------------------------------------------------------------
function startLevel(level)
	local l = levelsData[level]
	
	-- spawn enemies
	if l.spawn then
		initialSpawn = true
		timer.performWithDelay(l.spawn.delay, spawnAliens, l.spawn.times )
	end

	levelScreen(l)
end

-----------------------------------------------------------------------------------------
function levelCondition(e)
	if isPause then return true end

	local l = levelsData[levelNow]

	-- mission 1
	if l.goal and l.goal <= gold then
		-- victory
		victoryScreen(l)
	-- mission 2
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
	-- mission 3
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
	-- mission 4
	elseif l.colonize_all then
		local all_colonized = true
		for i = 1, group.numChildren, 1 do
			local g = group[i]
			if g.nameType == "planet" and not g.res.colonized and not g.enemy then
				print(g.name)
				all_colonized = false
			end
		end
		
		if all_colonized then
			victoryScreen(l)
		end
	-- mission 5
	elseif l.destroy_ms then
		--
	end
end