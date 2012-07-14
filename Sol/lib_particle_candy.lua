--module (..., package.seeall)

--[[
----------------------------------------------------------------
PARTICLE CANDY FOR CORONA SDK
----------------------------------------------------------------
PRODUCT  :		PARTICLE CANDY EFFECTS ENGINE
VERSION  :		1.0.18
AUTHOR   :		MIKE DOGAN / X-PRESSIVE.COM
WEB SITE :		http:www.x-pressive.com
SUPPORT  :		info@x-pressive.com
PUBLISHER:		X-PRESSIVE.COM
COPYRIGHT:		(C)2010,2011 MIKE DOGAN GAMES & ENTERTAINMENT

----------------------------------------------------------------

PLEASE NOTE:
A LOT OF HARD AND HONEST WORK HAS BEEN SPENT
INTO THIS PROJECT AND WE'RE STILL WORKING HARD
TO IMPROVE IT FURTHER.
IF YOU DID NOT PURCHASE THIS SOURCE LEGALLY,
PLEASE ASK YOURSELF IF YOU DID THE RIGHT AND
GET A LEGAL COPY (YOU'LL BE ABLE TO RECEIVE
ALL FUTURE UPDATES FOR FREE THEN) TO HELP
US CONTINUING OUR WORK. THE PRICE IS REALLY
FAIR. THANKS FOR YOUR SUPPORT AND APPRECIATION.

FOR FEEDBACK & SUPPORT, PLEASE CONTACT:
INFO@X-PRESSIVE.COM

]]--

-- OBJECT TO HOLD LOCAL VARIABLES AND FUNCTIONS
local V = {}

----------------------------------------------------------------
-- CHANGE THIS TO YOUR NEEDS:
----------------------------------------------------------------
V.debug 		= true
V.gGravity		= 0.98
V.gEmitterColorR	= 255
V.gEmitterColorG	= 255
V.gEmitterColorB	= 255
V.gFXFieldColorR	= 0
V.gFXFieldColorG	= 255
V.gFXFieldColorB	= 255


----------------------------------------------------------------
-- DO NOT CHANGE ANYTHING BELOW THIS LINE 
-- UNLESS YOU KNOW WHAT YOU ARE DOING !
----------------------------------------------------------------
V.PI 			= 4*math.atan(1)
V.RAD 			= V.PI/180
V.PI2			= 2*V.PI
V.gLastTime		= system.getTimer()
V.gSuspTime		= 0	-- THE MOMENT WHEN PARTICLE SYSTEM HAS BEEN FROZEN
V.gLostTime		= 0 -- TIME PASSED IN ALL FROZEN PHASES TOGETHER
V.gSystemFrozen		= 0 -- 1 = FROZEN BY USER, 2 = FROZEN AUTOMATICALLY
V.gParticlesRendered	= 0
V.Emitters 		= {}
V.EmitterIndex		= {}
V.FXFields		= {}
V.FXFieldIndex		= {}
V.ParticleTypes		= {}
V.ParticleTypeIndex	= {}
V.Particles		= {}
V.gMaxParticles		= 0
V.gSpriteAPI		= nil
V.gCleanUpCalled	= false

V.Abs  			= math.abs
V.Cos  			= math.cos
V.Sin  			= math.sin
V.Rnd  			= math.random
V.Ceil 			= math.ceil
V.Atan2 		= math.atan2
V.Sqrt			= math.sqrt

V.gScrW 		= display.contentWidth
V.gScrH 		= display.contentHeight

local StopAutoUpdate

if V.debug then print(); print(); print("--> PARTICLE SYSTEM READY. LET'S ROCK."); end


----------------------------------------------------------------
-- SET DEBUG MODE
----------------------------------------------------------------
local EnableDebug = function(state)
	V.debug = state == true and true or false
end
V.EnableDebug = EnableDebug

----------------------------------------------------------------
-- CREATE A NEW FX FIELD
-- MODE 0: ATTRACT PARTICLES
-- MODE 1: REJECT  PARTICLES
-- MODE 2: KILL    PARTICLES
----------------------------------------------------------------
local CreateFXField = function (name, mode, x, y, strength, radius, visible, fxID)

	-- NAME ALREADY EXISTS?
	if V.FXFields[name] ~= nil then
		print ("!!! Particles.CreateFXField(): FX FIELD '"..name.."' NOT CREATED - (ALREADY EXISTS)! NAME MUST BE UNIQUE.") 
		return
	end
	
	-- ADD NAME TO LIST OF EMITTERS
	table.insert(V.FXFieldIndex, name)

	fxID	= fxID		~= nil and fxID or 0
	visible	= visible  	== true and true or false
	mode	= mode 		~= nil and mode or 0
	strength= strength 	~= nil and strength or 1.0
	radius	= radius   	~= nil and radius or 1.0
	
	-- NEW FX FIELD
	V.FXFields[name] = display.newGroup()
	V.FXFields[name].x = x
	V.FXFields[name].y = y
	local Temp
	Temp = display.newCircle(0,0, radius)
	Temp:setFillColor  (0,0,0,0)
	Temp.strokeWidth  = 1
	Temp:setStrokeColor(V.gFXFieldColorR,V.gFXFieldColorG,V.gFXFieldColorB)
	V.FXFields[name]:insert(Temp)

	if mode == 3 or mode == 4 then
		Temp  = display.newLine(-radius*.1,0, -radius*.1,-radius*.5)
		Temp:append(-radius*.5, -radius*.5)
		Temp:append(0, -radius)
		Temp:append( radius*.5, -radius*.5)
		Temp:append( radius*.1, -radius*.5)
		Temp:append( radius*.1, 0)
		Temp:append(-radius*.1, 0)
		Temp.strokeWidth  = 1
		Temp:setColor(V.gFXFieldColorR,V.gFXFieldColorG,V.gFXFieldColorB)
		V.FXFields[name]:insert(Temp)
	end
	
	V.FXFields[name].name		= name
	V.FXFields[name].x	  	= x
	V.FXFields[name].y	 	= y
	V.FXFields[name].isVisible 	= visible
	V.FXFields[name].mode	  	= mode
	V.FXFields[name].strength  	= strength
	V.FXFields[name].radius	 	= radius
	V.FXFields[name].fxID		= fxID
	V.FXFields[name].enabled	= true
	V.FXFields[name].uniqueID	= x+y+radius+fxID+V.Ceil(V.Rnd()*5000)
	if V.debug then print ("--> Particles.CreateFxField(): ADDED FX FIELD '"..name.."'") end
end
V.CreateFXField = CreateFXField


----------------------------------------------------------------
-- RETURN FX FIELD OBJECT (OR NIL, IF IT DOESN'T EXIST)
----------------------------------------------------------------
local GetFXField = function (name)
	return V.FXFields[name]
end
V.GetFXField = GetFXField

----------------------------------------------------------------
-- ENABLE / DISABLE FX FIELD
----------------------------------------------------------------
local EnableFXField = function (name, state)
	if V.FXFields[name] == nil then print ("--> Particles.EnableFXField(): SPECIFIED FX FIELD '"..name.."' DOES NOT EXIST.") end
	V.FXFields[name].enabled = state == true and true or false
end
V.EnableFXField = EnableFXField


----------------------------------------------------------------
-- DELETE FX FIELD
----------------------------------------------------------------
local DeleteFXField = function (name)

	if V.FXFields[name] ~= nil then
		-- REMOVE NAME FROM FX FIELDS LIST
		local i,v = 0
		for i,v in ipairs(V.FXFieldIndex) do
			if v == name then table.remove(V.FXFieldIndex, i); break end
		end

		RemoveFXListener(name)

		-- REMOVE FX FIELD
		while V.FXFields[name].numChildren > 0 do V.FXFields[name][1]:removeSelf() end
		V.FXFields[name]:removeSelf()
		V.FXFields[name] = nil
		if V.debug then print ("--> Particles.DeleteFXField(): DELETED FX FIELD '"..name.."'") end
		return
	end

	print ("!!! Particles.DeleteFXField(): COULD NOT DELETE FX FIELD '"..name.."' (NOT FOUND)") 
end
V.DeleteFXField = DeleteFXField


----------------------------------------------------------------
-- ADD / REMOVE FX FIELD LISTENER
----------------------------------------------------------------
local AddFXListener = function (name, Listener)
	if V.FXFields[name] == nil then print ("--> Particles.AddFXListener(): SPECIFIED FX FIELD '"..name.."' DOES NOT EXIST.") end
	if Listener ~= nil then 
		V.FXFields[name].Listener = Listener
		V.FXFields[name]:addEventListener(V.FXFields[name].name, V.FXFields[name].Listener)
	end
end
V.AddFXListener = AddFXListener


local RemoveFXListener = function (name)
	if V.FXFields[name] == nil then print ("--> Particles.RemoveFXListener(): SPECIFIED FX FIELD '"..name.."' DOES NOT EXIST.") end
	if V.FXFields[name].Listener then 
		V.FXFields[name]:removeEventListener(V.FXFields[name].name, V.FXFields[name].Listener)
		V.FXFields[name].Listener = nil
	end		
end
V.RemoveFXListener = RemoveFXListener


----------------------------------------------------------------
-- REMOVE EMISSION LINES FROM EMITTER
----------------------------------------------------------------
local DeleteEmissionShape = function (name)

	if V.Emitters[name] == nil then 
		print ("!!! Particles.DeleteEmissionShape(): EMITTER '"..name.."' NOT FOUND!")
		return
	end

	if V.Emitters[name].Shape == nil then return end

	local i
	for i = 1, #V.Emitters[name].Shape.Segments do V.Emitters[name].Shape.Segments[i] = nil end
	V.Emitters[name].Shape.Segments = nil
	V.Emitters[name].Shape:removeSelf()
	V.Emitters[name].Shape	= nil

	if V.debug then print ("--> Particles.DeleteEmissionShape(): REMOVED EMISSION SHAPE FROM EMITTER '"..name.."'") end
end
V.DeleteEmissionShape = DeleteEmissionShape


----------------------------------------------------------------
-- CREATE A NEW EMITTER
----------------------------------------------------------------
local CreateEmitter = function (name, x, y, rotation, visible, loop, autoDestroy)

	-- NAME ALREADY EXISTS?
	if V.Emitters[name] ~= nil then
		print ("!!! Particles.CreateEmitter(): EMITTER '"..name.."' NOT CREATED - (ALREADY EXISTS)! NAME MUST BE UNIQUE.") 
		return
	end

	-- RESET GLOBAL TIMER (TIME PASSED SINCE LAST FRAME)
	-- TO AVOID CREATION OF MANY PARTICLES IF CLEAN UP
	-- WAS CALLED A WHILE AGO
	if V.gCleanUpCalled == true then 
		V.gLastTime      = system.getTimer()
		V.gCleanUpCalled = false
	end
	
	-- ADD NAME TO LIST OF EMITTERS
	table.insert(V.EmitterIndex, name)
	
	-- NEW EMITTER
	V.Emitters[name]      			= display.newGroup()
	V.Emitters[name].name			= name	-- EMITTER NAME
	V.Emitters[name].PTypes			= {}	-- REFERENCE TO A PARTICLE TYPE (V.ParticleTypes{})
	V.Emitters[name].PTypeIndex   		= {}	-- STRING ARRAY CONTAINING THE NAMES OF ATTACHED PARTICLE TYPES
	V.Emitters[name].PTypeSettings		= {}	-- OBJECT ARRAY CONTAINING EMISSION SETTINGS FOR EACH ATTACHED PARTICLE TYPE
	V.Emitters[name].active			= false -- TRUE WHEN STARTED, FALSE WHEN FINISHED COMPLETELY
	V.Emitters[name].startTime		= 0	-- TIME THE EMITTER HAS BEEN STARTED
	V.Emitters[name].scale			= 1.0
	V.Emitters[name].Listener		= nil 	-- LISTENER FUNCTION CALLED WHEN AN EMITTED PARTICLE DIES
	V.Emitters[name].x	  		= x
	V.Emitters[name].y	 		= y
	V.Emitters[name].xOrigin		= x-8
	V.Emitters[name].xReference		= 8
	V.Emitters[name].width 			= 1
	V.Emitters[name].isVisible 		= visible == true and true or false
	V.Emitters[name].loop		 	= loop == true and true or false
	V.Emitters[name].autoDestroy 		= autoDestroy == true and true or false
	V.Emitters[name].rotation  		= rotation ~= nil and rotation or 0
	V.Emitters[name].oneShot		= false

	V.Emitters[name].Sound 			= nil
	V.Emitters[name].SoundProperties  	= nil
	V.Emitters[name].soundAutoStop		= false
	V.Emitters[name].soundDelay		= 0
	V.Emitters[name].soundChannel		= 0
	
	V.Emitters[name].FollowObject		= nil

	-- EMITTER ARROW
	V.Emitters[name].Arrow = display.newLine(0,0, 16,0)
	V.Emitters[name].Arrow:setColor (V.gEmitterColorR,V.gEmitterColorG,V.gEmitterColorB, 255)
	V.Emitters[name].Arrow:append   (8,-24, 0,0)
	V.Emitters[name]:insert(V.Emitters[name].Arrow)
	group:insert(V.Emitters[name])
	
	if V.debug then print ("--> Particles.CreateEmitter(): ADDED EMITTER '"..name.."'") end
end
V.CreateEmitter = CreateEmitter


----------------------------------------------------------------
-- DELETE EMITTER
----------------------------------------------------------------
local DeleteEmitter = function (name)

	--print ("INDEX: "..table.concat(V.EmitterIndex, ", "))

	if V.Emitters[name] ~= nil then
		-- REMOVE NAME FROM EMITTER LIST
		local i,v = 0
		for i,v in ipairs(V.EmitterIndex) do
			if v == name then table.remove(V.EmitterIndex, i); break end
		end

		-- REMOVE EVENT LISTENER?	
		if V.Emitters[name].Listener ~= nil then 
			Runtime:removeEventListener( "particleKilled", V.Emitters[name].Listener )
			V.Emitters[name].Listener = nil
		end
		
		-- REMOVE EMITTER SOUND
		V.Emitters[name].Sound 			= nil
		V.Emitters[name].SoundProperties  = nil

		-- REMOVE REFERENCE TO FOLLOW OBJECT
		V.Emitters[name].FollowObject		= nil
		
		-- REMOVE EMITTER ARROW
		V.Emitters[name].Arrow			= nil
		
		-- REMOVE SHAPE SEGMENTS
		DeleteEmissionShape(name)

		-- REMOVE EMITTER
		V.Emitters[name].PTypes   		= nil
		V.Emitters[name].PTypeIndex		= nil
		V.Emitters[name].PTypeSettings	= nil
		V.Emitters[name]:removeSelf()
		V.Emitters[name] 					= nil
		if V.debug then print ("--> Particles.DeleteEmitter(): DELETED EMITTER '"..name.."'") end
		return
	end

	print ("!!! Particles.DeleteEmitter(): COULD NOT DELETE EMITTER '"..name.."' (NOT FOUND)") 
end
V.DeleteEmitter = DeleteEmitter


----------------------------------------------------------------
-- LIST EMITTERS
----------------------------------------------------------------
local ListEmitters = function ()

	local i, pName, pValue, eName, eValue
	
	print ()
	print ("---------------------------")
	print (#V.ParticleTypeIndex.." PARTICLE TYPES:")

	for pName,pValue in pairs(V.ParticleTypes) do 
		print("- '"..pName.."'")
	end

	print ()
	print (#V.EmitterIndex.." EMITTERS:")
	for eName,eValue in pairs(V.Emitters) do 
		print ()
		print ("EMITTER: '"..V.Emitters[eName].name.."'")
		
		for i,pValue in ipairs(V.Emitters[eName].PTypeIndex) do
			print ("|-"..pValue.."'")
		end
	end
	print ("---------------------------")
	print ()
end
V.ListEmitters = ListEmitters


----------------------------------------------------------------
-- START EMITTER
----------------------------------------------------------------
local StartEmitter = function (name, oneShotMode)

	if V.gSystemFrozen > 0 then
		print ("!!! Particles.StartEmitter(): CANNOT START EMITTER WHILE SYSTEM IS FROZEN. RESUME FIRST!")
		return
	end

	if V.Emitters[name] == nil then 
		print ("!!! Particles.StartEmitter(): EMITTER '"..name.."' NOT FOUND!")
		return
	end
	
	local now = system.getTimer() - V.gLostTime
	local PSettings, j, pName
	
	V.Emitters[name].active       = true
	V.Emitters[name].startTime    = now
	V.Emitters[name].oneShot      = oneShotMode == true and true or false
	V.Emitters[name].soundChannel = 0
	
	-- PRE-CALCULATE START AND END TIME FOR ATTACHED PARTICLE TYPES
	for j,pName in ipairs(V.Emitters[name].PTypeIndex) do
		PSettings 			= V.Emitters[name].PTypeSettings[pName]
		PSettings.startTime 		= now + PSettings.delay
		PSettings.endTime   		= now + PSettings.delay + PSettings.duration
		PSettings.particlesToEmit	= 0
		PSettings.active 		= true
	end
	
	if V.debug then print ("--> Particles.StartEmitter(): EMITTER '"..name.."' STARTED.") end
end
V.StartEmitter = StartEmitter


----------------------------------------------------------------
-- STOP EMITTER
----------------------------------------------------------------
local StopEmitter = function (name)

	if V.Emitters[name] == nil then 
		print ("!!! Particles.StopEmitter(): EMITTER '"..name.."' NOT FOUND!")
		return
	end
	
	-- STOP SOUND?
	if V.Emitters[name].soundAutoStop == true and V.Emitters[name].soundChannel > 0 then
		audio.stop(V.Emitters[name].soundChannel)
		V.Emitters[name].soundChannel = 0
	end
	
	local j, pName
	for j,pName in ipairs(V.Emitters[name].PTypeIndex) do
		V.Emitters[name].PTypeSettings[pName].active = false
	end
	
	V.Emitters[name].active = false

	if V.debug then print ("--> Particles.StopEmitter(): EMITTER '"..name.."' STOPPED.") end
end
V.StopEmitter = StopEmitter


----------------------------------------------------------------
-- ADD EMISSION SHAPE LINES TO EMITTER
----------------------------------------------------------------
local DefineEmissionShape = function (name, lines, useEmitterRotation, cornersOnly, visible)

	local Emitter = V.Emitters[name]

	if Emitter == nil then 
		print ("!!! Particles.AddCustomEmissionShape(): EMITTER '"..name.."' NOT FOUND!")
		return
	end

	-- CREATE SHAPE GROUP 
	Emitter.Shape 		 = display.newGroup()
	Emitter.Shape.myWidth    = 0
	Emitter.Shape.myAngle    = 0
	Emitter.Shape.Segments   = {}
	Emitter.Shape.x 	 = 8
	Emitter:insert(Emitter.Shape)

	Emitter.Shape.useEmitterRotation = useEmitterRotation == true and true or false
	Emitter.Shape.cornersOnly	 = cornersOnly	  == true and true or false

	local This, Line, i
	local Prev = Emitter.Shape
	
	i = 1; while i < #lines do
		This 	      = display.newGroup()
		This.myWidth  = lines[i]
		This.myAngle  = lines[i+1]
		table.insert(Emitter.Shape.Segments, This)
		Prev:insert(This) 
		This.x        = Prev.myWidth
		This.rotation = Prev.myAngle * -1 + This.myAngle

		-- DRAW LINE?
		if visible == true then
			Line = display.newLine(0,0, This.myWidth,0)
			Line:setColor(255,255,0, 255)
			This:insert(Line)
		end
		
		Prev = This; i = i + 2
	end
	
	--for i = 1, #Emitter.Shape.Segments do
	--	print(Emitter.Shape.Segments[i].myWidth)
	--end
	
	if V.debug then print ("--> Particles.AddCustomEmissionShape(): ADDED EMISSION SHAPE TO EMITTER '"..name.."'") end
end
V.DefineEmissionShape = DefineEmissionShape


----------------------------------------------------------------
-- RETURN EMITTER OBJECT (OR NIL, IF IT DOESN'T EXIST)
----------------------------------------------------------------
local GetEmitter = function (name)
	return V.Emitters[name]
end
V.GetEmitter = GetEmitter


----------------------------------------------------------------
-- CHECK IF AN EMITTER IS ACTIVE
----------------------------------------------------------------
local EmitterIsActive = function (name)
	if V.Emitters[name] ~= nil then return V.Emitters[name].active end
	print ("!!! Particles.EmitterIsActive(): COULD NOT FIND EMITTER '"..name.."'") 
end
V.EmitterIsActive = EmitterIsActive


----------------------------------------------------------------
-- SET EMITTER SCALE
----------------------------------------------------------------
local SetEmitterScale = function (name, scale)

	if V.Emitters[name] ~= nil then 
		V.Emitters[name].scale  = scale
		V.Emitters[name].xScale = scale
		V.Emitters[name].yScale = scale
		return 
	end

	print ("!!! Particles.SetEmitterScale(): COULD NOT FIND EMITTER '"..name.."'") 
end
V.SetEmitterScale = SetEmitterScale


----------------------------------------------------------------
-- GET EMITTER SCALE
----------------------------------------------------------------
local GetEmitterScale = function (name, scale)
	if V.Emitters[name] ~= nil then return V.Emitters[name].scale end
	print ("!!! Particles.GetEmitterScale(): COULD NOT FIND EMITTER '"..name.."'") 
end
V.GetEmitterScale = GetEmitterScale


----------------------------------------------------------------
-- ADD EMITTER LISTENER
----------------------------------------------------------------
local SetEmitterListener = function (name, Listener)

	if V.Emitters[name] ~= nil then 

		-- UNREGISTER PREVIOUS LISTENER?
		if V.Emitters[name].Listener ~= nil then
			Runtime:removeEventListener( "particleKilled", V.Emitters[name].Listener ) 
			V.Emitters[name].Listener = nil
		end

		-- REGISTER NEW LISTENER?
		if Listener ~= nil then
			V.Emitters[name].Listener = Listener
			Runtime:addEventListener( "particleKilled", V.Emitters[name].Listener ) 
		end
		return
	end

	print ("!!! Particles.SetEmitterListener(): COULD NOT FIND EMITTER '"..name.."'") 
end
V.SetEmitterListener = SetEmitterListener


----------------------------------------------------------------
-- ADD EMITTER SOUND EFFECT
----------------------------------------------------------------
local SetEmitterSound = function (name, SoundID, delay, autoStop, SoundProperties)

	if V.Emitters[name] ~= nil then 
	
		-- DETACH A SOUND?
		if soundID == nil and autoStop == nil and SoundProperties == nil then
			V.Emitters[name].Sound           = nil
			V.Emitters[name].SoundProperties = nil
			V.Emitters[name].soundAutoStop   = false
			V.Emitters[name].soundDelay      = 0
			if V.debug then print ("--> Particles.SetEmitterSound(): REMOVED SOUND FROM EMITTER '"..name.."'.") end
			return
		end

		-- ATTACH NEW SOUND
		if SoundID ~= nil then
			if SoundProperties == nil then SoundProperties = { channel = 1, loops = 1, fadeIn = 1000 } end
			V.Emitters[name].Sound 		= nil
			V.Emitters[name].SoundProperties= nil
			V.Emitters[name].Sound 		= SoundID
			V.Emitters[name].SoundProperties= SoundProperties
			V.Emitters[name].soundDelay  	= delay ~= nil and delay or 0
			V.Emitters[name].soundAutoStop	= autoStop == true and true or false
			if V.debug then print ("--> Particles.SetEmitterSound(): ATTACHED SOUND TO EMITTER '"..name.."'.") end
			return
		end

	end

	print ("!!! Particles.SetEmitterSound(): COULD NOT FIND EMITTER '"..name.."' OR MISSING SOUND ID.") 
end
V.SetEmitterSound = SetEmitterSound


----------------------------------------------------------------
-- LET EMITTER AUTO-FOLLOW A TARGET OBJECT
----------------------------------------------------------------
local SetEmitterTarget = function (emitterName, FollowTarget, followRotation, followRotationOffset, xOffset, yOffset)
	local Emitter = V.Emitters [emitterName]

	-- EMITTER EXISTS?
	if Emitter == nil then print ("!!! Particles.FollowTarget(): EMITTER '"..emitterName.."' NOT FOUND."); return end
	
	-- DISABLE AUTO-FOLLOW?
	if FollowTarget == nil then 
		Emitter.FollowObject   		 = nil
		Emitter.followRotation 		 = false
		Emitter.followRotationOffset = 0
		Emitter.xOffset, Emitter.yOffset = 0, 0
		return
	end

	Emitter.FollowObject   		 = FollowTarget
	Emitter.followRotation 		 = followRotation
	Emitter.followRotationOffset = followRotationOffset ~= nil and followRotationOffset or 0
	Emitter.xOffset, Emitter.yOffset = xOffset, yOffset
end
V.SetEmitterTarget = SetEmitterTarget


----------------------------------------------------------------
-- CHANGE A PARTICLE TYPE'S EMISSION RATE
----------------------------------------------------------------
local ChangeEmissionRate = function (emitterName, particleName, emissionRate)
	local Emitter   = V.Emitters [emitterName]
	local PSettings = Emitter.PTypeSettings[particleName]

	-- EMITTER EXISTS?
	if Emitter == nil then print ("!!! Particles.SetEmissionRate(): EMITTER '"..emitterName.."' NOT FOUND."); return end
	
	-- PARTICLE TYPE NOT FOUND?
	if PSettings == nil then 
		if V.debug then print ("!!! Particles.SetEmissionRate(): PARTICLE TYPE '"..particleName.."' NOT ATTACHED TO EMITTER '"..emitterName.."'.") end
		return
	end

	-- UPDATE EMISSION RATE
	PSettings.emissionRate = emissionRate / 1000.0 
end
V.ChangeEmissionRate = ChangeEmissionRate


----------------------------------------------------------------
-- PRIVATE: CONVERT TIME-RELEVANT PROPERTIES OF 
-- A PARTICLE TYPE TO CHANGES PER MILLISECS
----------------------------------------------------------------
local PrepareParticleSettings = function (name)

	if V.ParticleTypes[name] == nil then
		print ("!!! Particles.PrepareParticleSettings(): PARTICLE TYPE '"..name.."' NOT FOUND!")
		return
	end
	
	-- AVOID ANNOYING WARNINGS
	if V.ParticleTypes[name].scaleStart <= 0.0 then V.ParticleTypes[name].scaleStart = 0.0001 end

	-- TIME-RELEVANT PROPERTIES, CONVERTED TO CHANGE PER MILLISECS
	V.ParticleTypes[name].vs  = V.ParticleTypes[name].velocityStart  	/ 1000
	V.ParticleTypes[name].vc  = V.ParticleTypes[name].velocityChange 	/ 1000
	V.ParticleTypes[name].vv  = V.ParticleTypes[name].velocityVariation 	/ 1000
	V.ParticleTypes[name].rc  = V.ParticleTypes[name].rotationChange    	/ 1000
	V.ParticleTypes[name].fi  = V.ParticleTypes[name].fadeInSpeed       	/ 1000
	V.ParticleTypes[name].fo  = V.ParticleTypes[name].fadeOutSpeed      	/ 1000
	V.ParticleTypes[name].si  = V.ParticleTypes[name].scaleInSpeed      	/ 1000
	V.ParticleTypes[name].so  = V.ParticleTypes[name].scaleOutSpeed     	/ 1000
	V.ParticleTypes[name].we  = V.ParticleTypes[name].weight            	/ 1000
	if V.ParticleTypes[name].colorChange ~= 0 then
		V.ParticleTypes[name].ccR = V.ParticleTypes[name].colorChange[1]    / 1000
		V.ParticleTypes[name].ccG = V.ParticleTypes[name].colorChange[2]    / 1000
		V.ParticleTypes[name].ccB = V.ParticleTypes[name].colorChange[3]    / 1000
	end
end
V.PrepareParticleSettings = PrepareParticleSettings


----------------------------------------------------------------
-- CREATE A PARTICLE TYPE
----------------------------------------------------------------
local CreateParticleType = function (name, Properties)

	-- NAME ALREADY EXISTS?
	if V.ParticleTypes[name] ~= nil then
		print ("!!! Particles.CreateParticleType(): PARTICLE TYPE '"..name.."' NOT CREATED - (ALREADY EXISTS)! NAME MUST BE UNIQUE.")
		return
	elseif Properties == nil or type(Properties) ~= "table" then
		print ("!!! Particles.CreateParticleType(): '"..name.."' NOT CREATED - PLEASE SPECIFY A PROPERTIES TABLE AS PARAMETER!")
		return
	end

	-- ADD NAME TO LIST OF PARTICLE TYPES
	table.insert(V.ParticleTypeIndex, name)
	
	V.ParticleTypes[name]      = {}
	V.ParticleTypes[name].name = name
	
	-- DEFAULT PROPERTIES
	V.ParticleTypes[name].imagePath 		= ""
	V.ParticleTypes[name].imageWidth 		= 16
	V.ParticleTypes[name].imageHeight		= 16
	V.ParticleTypes[name].xReference 		= 0
	V.ParticleTypes[name].yReference 		= 0
	V.ParticleTypes[name].SpriteSet 		= nil
	V.ParticleTypes[name].animSequence		= ""
	V.ParticleTypes[name].weight			= 0.0
	V.ParticleTypes[name].velocityStart		= 0.0
	V.ParticleTypes[name].velocityChange		= 0.0
	V.ParticleTypes[name].velocityVariation		= 0.0
	V.ParticleTypes[name].directionVariation	= 0.0
	V.ParticleTypes[name].rotationStart 		= 0
	V.ParticleTypes[name].rotationVariation		= 0
	V.ParticleTypes[name].rotationChange		= 0
	V.ParticleTypes[name].autoOrientation		= false
	V.ParticleTypes[name].useEmitterRotation	= true
	V.ParticleTypes[name].alphaStart		= 1.0
	V.ParticleTypes[name].alphaVariation		= 0.0
	V.ParticleTypes[name].fadeInSpeed		= 0.0
	V.ParticleTypes[name].fadeOutSpeed		= 0.0
	V.ParticleTypes[name].fadeOutDelay		= 0
	V.ParticleTypes[name].scaleStart		= 1.0
	V.ParticleTypes[name].scaleVariation		= 0.0
	V.ParticleTypes[name].scaleInSpeed		= 0.0
	V.ParticleTypes[name].scaleMax			= 0.0
	V.ParticleTypes[name].scaleOutSpeed		= 0.0
	V.ParticleTypes[name].scaleOutDelay		= 0
	V.ParticleTypes[name].bounceX			= false
	V.ParticleTypes[name].bounceY			= false
	V.ParticleTypes[name].bounciness		= 1.0
	V.ParticleTypes[name].emissionShape		= 0
	V.ParticleTypes[name].emissionRadius		= 0
	V.ParticleTypes[name].killOutsideScreen 	= true 
	V.ParticleTypes[name].lifeTime			= 1000
	V.ParticleTypes[name].faceEmitter		= false
	V.ParticleTypes[name].fxID			= 0
	V.ParticleTypes[name].PhysicsMaterial		= nil
	V.ParticleTypes[name].PhysicsProperties		= nil
	V.ParticleTypes[name].randomMotionMode		= 0
	V.ParticleTypes[name].randomMotionInterval	= 0
	V.ParticleTypes[name].randomMotionAmount  	= 0
	V.ParticleTypes[name].text			= nil
	V.ParticleTypes[name].font			= native.systemFont
	V.ParticleTypes[name].fontSize			= 12
	V.ParticleTypes[name].textColor			= { 255,255,255 }
	V.ParticleTypes[name].blendMode			= "normal"
	V.ParticleTypes[name].colorStart		= {255,255,255}
	V.ParticleTypes[name].colorChange		= 0
	
	-- SET USER PROPERTIES
	local n,v
	for n,v in pairs(Properties) do V.ParticleTypes[name][n] = v end

	PrepareParticleSettings (name)
	
	-- PRELOAD IMAGE TO AVOID HICKUPS
	-- V.ParticleTypes[name].Image = display.newImageRect(imagePath, imageWidth, imageHeight) 
	-- V.ParticleTypes[name].Image.isVisible = false

	if V.debug then print ("--> Particles.CreateParticleType(): CREATED PARTICLE TYPE '"..name.."'.") end
end
V.CreateParticleType = CreateParticleType


----------------------------------------------------------------
-- PRIVATE: DELETE A PARTICLE TYPE
-- CAUTION: PARTICLE TYPES MUST NOT BE DELETED IF ANY PARTICLES
--          STILL EXIST. DELETE P.TYPES ONLY USING CLEANUP()!
----------------------------------------------------------------
local DeleteParticleType = function (name)

	if V.ParticleTypes[name] ~= nil then
	
		local i, v, j, w

		-- DETACH FROM EMITTERS
		for i,v in pairs(V.EmitterIndex) do
			if V.Emitters[v].PTypes[name] ~= nil then
				-- REMOVE REFERENCES TO PARTCLE TYPE
				V.Emitters[v].PTypes       [name] = nil
				V.Emitters[v].PTypeSettings[name] = nil

				-- REMOVE NAME FROM EMITTER'S PARTICLE TYPES INDEX
				for j,w in ipairs(V.Emitters[v].PTypeIndex) do
					if w == name then table.remove(V.Emitters[v].PTypeIndex, j); break end
				end
				
				if V.debug then print ("--> Particles.DeleteParticleType(): REMOVING '"..name.."' FROM EMITTER '"..V.Emitters[v].name.."'") end
				break
			end
		end
	
		-- REMOVE NAME FROM PARTICLE TYPES LIST
		for i,v in ipairs(V.ParticleTypeIndex) do
			if v == name then table.remove(V.ParticleTypeIndex, i); break end
		end

		-- REMOVE PRELOADED IMAGE
		-- V.ParticleTypes[name].Image:removeSelf()
		-- V.ParticleTypes[name].Image = nil

		-- REMOVE PARTICLE TYPE
		V.ParticleTypes[name].SpriteSet         = nil
		V.ParticleTypes[name].TapListener       = nil
		V.ParticleTypes[name].PhysicsMaterial   = nil
		V.ParticleTypes[name].PhysicsProperties	= nil
		V.ParticleTypes[name]                   = nil
		if V.debug then print ("--> Particles.DeleteParticleType(): DELETED PARTICLE TYPE '"..name.."'") end
		return
	end

	print ("!!! Particles.DeleteEmitter(): COULD NOT DELETE PARTICLE TYPE '"..name.."' (NOT FOUND)") 
end
V.DeleteParticleType = DeleteParticleType


----------------------------------------------------------------
-- SET A SINGLE PARTICLE TYPE PROPERTY
----------------------------------------------------------------
local SetParticleProperty = function (name, property, value)

	local PType = V.ParticleTypes[name]

	if PType ~= nil then
		if PType[property] == nil then print("!!! Particles.SetParticleProperty(): YOU TRIED TO SET AN UNKNOWN PROPERTY: "); print(property) return end
		PType[property] = value
		PrepareParticleSettings (name)
		if V.debug then print ("--> Particles.SetParticleProperty(): SET "..name.."."..property.." ("..type(value)..").") end
		return
	end
	print ("!!! Particles.SetParticleProperty(): COULD NOT FIND PARTICLE TYPE '"..name.."'") 
end
V.SetParticleProperty = SetParticleProperty


----------------------------------------------------------------
-- ADD PARTICLE TYPE TO EMITTER
----------------------------------------------------------------
local AttachParticleType = function (emitterName, particleName, emissionRate, duration, startDelay)

	local Emitter = V.Emitters      [emitterName ]
	local PType   = V.ParticleTypes [particleName]

	-- EMITTER EXISTS?
	if Emitter == nil then
		print ("!!! Particles.AddParticleType(): EMITTER '"..emitterName.."' NOT FOUND.") 
		return 
	end

	-- PARTICLE TYPE EXISTS?
	if PType == nil then
		print ("!!! Particles.AddParticleType(): PARTICLE TYPE '"..particleName.."' NOT FOUND.") 
		return 
	end
	
	local i, v
	
	-- CHECK IF ALREADY ATTACHED
	for i,v in ipairs(Emitter.PTypeIndex) do
		if v == particleName then 
			print ("!!! Particles.AddParticleType(): PARTICLE TYPE '"..particleName.."' ALREADY ATTACHED TO EMITTER '"..emitterName.."'.")
			return
		end
	end

	-- ADD NAME TO LIST OF ATTACHED PARTICLE TYPES
	table.insert(Emitter.PTypeIndex, particleName)

	-- ATTACH PARTICLE TYPE
	Emitter.PTypes[particleName]   		= PType
	Emitter.PTypeSettings[particleName] = {}
	Emitter.PTypeSettings[particleName].name 		= particleName
	Emitter.PTypeSettings[particleName].emissionRate 	= emissionRate / 1000.0
	Emitter.PTypeSettings[particleName].delay 	 	= startDelay
	Emitter.PTypeSettings[particleName].duration 	 	= duration
	Emitter.PTypeSettings[particleName].startTime 	 	= 0
	Emitter.PTypeSettings[particleName].endTime 	 	= 0
	Emitter.PTypeSettings[particleName].particlesToEmit	= 0
	Emitter.PTypeSettings[particleName].active			= false
	if V.debug then print ("--> Particles.AddParticleType(): ADDED PARTICLE TYPE '"..particleName.."' TO EMITTER '"..emitterName.."'.") end
end
V.AttachParticleType = AttachParticleType


----------------------------------------------------------------
-- DETACH PARTICLE TYPE(S) FROM EMITTER
----------------------------------------------------------------
local DetachParticleTypes = function (emitterName, particleName, keepSound)

	local Emitter = V.Emitters [emitterName]
	local num	  = 0
	local i, v

	-- EMITTER EXISTS?
	if Emitter == nil then
		print ("!!! Particles.RemoveParticleType(): EMITTER '"..emitterName.."' NOT FOUND.") 
		return 
	end
	
	-- STOP EMITTER (AND SOUND)
	StopEmitter(emitterName)
	
	-- DELETE ATTACHED SOUND?
	if keepSound ~= true then SetEmitterSound(emitterName) end
	
	-- REMOVE ALL PARTICLE TYPES?
	if particleName == nil or particleName == "" then
		for i,v in ipairs(Emitter.PTypeIndex) do
			Emitter.PTypes       [v] = nil
			Emitter.PTypeSettings[v] = nil
			num = num + 1
		end
		while (#Emitter.PTypeIndex) > 0 do table.remove(Emitter.PTypeIndex, 1) end

	-- REMOVE A CERTAIN PARTICLE TYPE
	else
		-- DETACH FROM EMITTERS
		if Emitter.PTypes[particleName] ~= nil then
			-- REMOVE REFERENCES TO PARTCLE TYPE
			Emitter.PTypes       [particleName] = nil
			Emitter.PTypeSettings[particleName] = nil
			-- REMOVE NAME FROM EMITTER'S PARTICLE TYPES INDEX
			for i,v in ipairs(Emitter.PTypeIndex) do
				if v == particleName then table.remove(Emitter.PTypeIndex, i); break end
			end
			num = 1
		end
	end

	if V.debug then print ("--> Particles.RemoveParticleType(): REMOVED "..num.." PARTICLE TYPE(S) FROM EMITTER '"..emitterName.."'.") end
end
V.DetachParticleTypes = DetachParticleTypes


----------------------------------------------------------------
-- PRIVATE: REMOVE A PARTICLE FROM SCREEN AND MEMORY
----------------------------------------------------------------
local DeleteParticle = function (index)

	if V.Particles[index] ~= nil then
		if V.Particles[index].PType.TapListener ~= nil then
			V.Particles[index]:removeEventListener("tap", V.Particles[index].PType.TapListener)
		end

		V.Particles[index].Emitter     = nil
		V.Particles[index].PType       = nil
		V.Particles[index].Listener    = nil
		V.Particles[index]:removeSelf()
		V.Particles[index]             = nil
	end
end
V.DeleteParticle = DeleteParticle


----------------------------------------------------------------
-- REMOVE ALL OR CERTAIN PARTICLES FROM SCREEN AND MEMORY
----------------------------------------------------------------
local ClearParticles = function (emitterName)
	
	local i
	
	if emitterName == nil then
		for i = 1, V.gMaxParticles do DeleteParticle(i)end
		-- REDUCE MAXPARTICLES
		V.gMaxParticles = 0
	else
		for i=1, V.gMaxParticles do 
			if V.Particles[i] ~= nil then
				if V.Particles[i].emitterName == emitterName then DeleteParticle(i) end
			end
		end
	end

	collectgarbage("collect")

	if V.debug then print ("--> Particles.ClearParticles()") end
end
V.ClearParticles = ClearParticles


----------------------------------------------------------------
-- CLEAN UP
----------------------------------------------------------------
local CleanUp = function ()

	StopAutoUpdate()

	-- DELETE PARTICLES
	ClearParticles()

	-- DELETE FX FIELDS
	while (#V.FXFieldIndex) > 0 do DeleteFXField(V.FXFieldIndex[1]) end

	-- DELETE PARTICLE TYPES
	while (#V.ParticleTypeIndex) > 0 do DeleteParticleType(V.ParticleTypeIndex[1]) end

	-- DELETE EMITTERS
	while (#V.EmitterIndex) > 0 do DeleteEmitter(V.EmitterIndex[1]) end
	
	-- RESET ACCUMULATED FREEZE-TIME
	V.gLostTime 	  	= 0
	V.gSystemFrozen		= 0
	V.gParticlesRendered 	= 0

	-- REMEMBER THAT UPDATE() HASN'T BEEN CALLED 
	-- FOR A LONGER PERIOD NEXT TIME AN EMITTER IS CREATED
	V.gCleanUpCalled      = true

	collectgarbage("collect")

	if V.debug then print ("--> Particles.CleanUp(): FINISHED.") end
end
V.CleanUp = CleanUp


----------------------------------------------------------------
-- UPDATE
----------------------------------------------------------------
local Update = function ()

	if V.gSystemFrozen > 0 then return end

	local Emitter
	local now      = system.getTimer() - V.gLostTime
	local diffTime = now - V.gLastTime; V.gLastTime = now
	local i, j, v, n, eName, pName, dirAngle, ra
	
	-- FOR CUSTOM EMISSION SHAPES
	local emitterX, emitterY, emitterRot, emitterScale, emitterAlpha, EmitterParent, dx, dy, r
	local num, Segment, DummyGroup

	-- LOOP EMITTERS
	for i,eName in ipairs(V.EmitterIndex) do
		Emitter = V.Emitters[eName]

		if Emitter.active then

			emitterX 	 = Emitter.x
			emitterY 	 = Emitter.y
			emitterScale = Emitter.scale
			emitterAlpha = Emitter.alpha
			emitterRot	 = Emitter.rotation
			EmitterParent= Emitter.parent
		
			-- FOLLOW AN OBJECT?
			if Emitter.FollowObject ~= nil then
				r = Emitter.FollowObject.rotation
				dx = Emitter.xOffset*math.cos(r*V.RAD) - Emitter.yOffset*math.sin(r*V.RAD)
				dy = Emitter.xOffset*math.sin(r*V.RAD) + Emitter.yOffset*math.cos(r*V.RAD)
				emitterX = Emitter.FollowObject.x + dx
				emitterY = Emitter.FollowObject.y + dy
				Emitter.x = emitterX
				Emitter.y = emitterY
				if Emitter.followRotation == true then 
					emitterRot = Emitter.FollowObject.rotation + Emitter.followRotationOffset 
					Emitter.rotation = emitterRot
				end
			end
		
			-- SOUND ATTACHED?
			if Emitter.Sound ~= nil then
				-- NOT STARTED YET?
				if Emitter.soundChannel == 0 then
					-- START NOW?
					if now-Emitter.startTime > Emitter.soundDelay then
						-- STOP THIS CHANNEL?
						if Emitter.SoundProperties.channel > 0 then audio.stop(Emitter.SoundProperties.channel) end
						-- PLAY SOUND
						Emitter.soundChannel = audio.play(Emitter.Sound, Emitter.SoundProperties)
					end
				end
			end

			-- LOOP EMITTER'S PARTICLE TYPES
			for j,pName in ipairs(Emitter.PTypeIndex) do
				local PType 	= V.ParticleTypes      [pName]
				local PSettings = Emitter.PTypeSettings[pName]
				
				-- PARTICLE TYPE'S EMISSION STARTED?
				if PSettings.active == true and now > PSettings.startTime then

					-- EMIT PARTICLES OF THIS TYPE?
					if Emitter.oneShot == true then
						PSettings.particlesToEmit = PSettings.emissionRate * 1000.0
					else
						PSettings.particlesToEmit = PSettings.particlesToEmit + diffTime * PSettings.emissionRate
					end

					
	 				ra = PType.emissionRadius * emitterScale

					
                    while PSettings.particlesToEmit >= 1.0 do
						-- GET NEXT FREE SLOT
						local slot = 1; while V.Particles[slot] ~= nil do slot = slot + 1 end

						if slot > V.gMaxParticles then V.gMaxParticles = slot end

						-- USE CUSTOM EMISSION SHAPE?
						if Emitter.Shape ~= nil then
							if DummyGroup == nil then DummyGroup = display.newGroup() end

							num     = V.Ceil(V.Rnd()*#Emitter.Shape.Segments)
							Segment = Emitter.Shape.Segments[num]
							if Emitter.Shape.cornersOnly == false then 
								emitterX, emitterY  = Segment:localToContent(V.Rnd()*Segment.myWidth, 0)
							else
								emitterX, emitterY  = Segment:localToContent(0, 0)
							end
							Segment:insert(DummyGroup)
							if Emitter.Shape.useEmitterRotation ~= true then emitterRot = emitterRot + Segment.myAngle end
						end

						----------------------------------------
						-- NEW PARTICLE
						----------------------------------------
						if PType.text ~= nil then
							V.Particles[slot] = display.newText( PType.text, emitterX, emitterY, PType.font, PType.fontSize )
							V.Particles[slot]:setTextColor( PType.textColor[1],PType.textColor[2],PType.textColor[3]  )
							V.Particles[slot].xReference = PType.xReference
							V.Particles[slot].yReference = PType.yReference
						elseif PType.SpriteSet == nil then
							V.Particles[slot] = display.newImageRect(PType.imagePath,PType.imageWidth,PType.imageHeight)
							V.Particles[slot].xReference = PType.xReference
							V.Particles[slot].yReference = PType.yReference
						else
							if V.gSpriteAPI ~= nil then 
								V.Particles[slot] = V.gSpriteAPI.newSprite(PType.SpriteSet)
								V.Particles[slot]:prepare(PType.animSequence)
								V.Particles[slot]:play()
							else
								print ("--------------------------------------------------------") 
								print ("!!! Particles.Update(): SPRITE API NOT SET! USE UseSpriteAPI() TO SET A REFERENCE!") 
								print ("--------------------------------------------------------") 
							end
						end

						local Particle = V.Particles[slot]
						--Particle.name = "PARTICLE"
						
						-- SET PARTICLE BLEND MODE
						Particle.blendMode = PType.blendMode
						
						-- APPLY COLOR?
						if Particle.setFillColor ~= nil then
							Particle.currColor = {PType.colorStart[1], PType.colorStart[2], PType.colorStart[3]}
							Particle:setFillColor(PType.colorStart[1], PType.colorStart[2], PType.colorStart[3])
						end
						
						-- ADD TAP LISTENER?
						if PType.TapListener ~= nil then Particle:addEventListener("tap", PType.TapListener) end

						-- PARTICLE INITIAL POSITION
						if PType.emissionShape == 0 then
							Particle.x 		= emitterX
							Particle.y 		= emitterY
						elseif PType.emissionShape == 1 then
							local lineAngleL	= V.PI-(emitterRot-90)/360*V.PI2
							local lineStep		= V.Rnd() * ra*2
							Particle.x 		= emitterX + (V.Sin(lineAngleL) * ra) - V.Sin(lineAngleL) * lineStep
							Particle.y 		= emitterY + (V.Cos(lineAngleL) * ra) - V.Cos(lineAngleL) * lineStep
						elseif PType.emissionShape == 2 then
							local ringAngle = V.PI-(V.Rnd()*360)/360*V.PI2
							Particle.x 		= emitterX + (V.Sin(ringAngle) * ra)
							Particle.y 		= emitterY + (V.Cos(ringAngle) * ra)
						elseif PType.emissionShape == 3 then
							local discAngle  	= V.PI-(V.Rnd()*360)/360*V.PI2
							local discRadius 	= V.Rnd() * ra
							Particle.x 		 = emitterX + (V.Sin(discAngle) * discRadius)
							Particle.y 		 = emitterY + (V.Cos(discAngle) * discRadius)
						end
						
						-- PARTICLE INITIAL ALPHA & SCALE
						Particle.alfa	 	 = PType.alphaStart + V.Rnd()*PType.alphaVariation
						Particle.scale 		 = PType.scaleStart + V.Rnd()*PType.scaleVariation
						Particle.emitterAlpha= emitterAlpha
						Particle.emitterScale= emitterScale

						-- PARTICLE INITIAL ROTATION
						if PType.faceEmitter == false then
							Particle.rotation 	= PType.rotationStart + V.Ceil(V.Rnd()*PType.rotationVariation)
							if PType.useEmitterRotation then Particle.rotation = Particle.rotation + emitterRot end
							dirAngle			= emitterRot
						else
	   						Particle.rotation   = ( V.Atan2( (Particle.y-emitterY), (Particle.x-emitterX) ) * (180/V.PI) ) - 90 
							dirAngle			= Particle.rotation
						end
						
						-- PARTICLE INITIAL SPEED
						dirAngle				= dirAngle - PType.directionVariation*0.5 + V.Rnd()*PType.directionVariation
						dirAngle				= V.PI-dirAngle/360*V.PI2
						Particle.xSpeed	 		= V.Sin(dirAngle) * (PType.vs + V.Rnd()*PType.vv )
						Particle.ySpeed	 		= V.Cos(dirAngle) * (PType.vs + V.Rnd()*PType.vv )
						Particle.weight			= PType.we * V.gGravity
						
						Particle.startTime 		= now
						Particle.killTime 		= now + PType.lifeTime
						Particle.fadeOutTime	= now + PType.fadeOutDelay
						Particle.scaleOutTime	= now + PType.scaleOutDelay
						Particle.PType			= PType
						Particle.lastX			= Particle.x
						Particle.lastY			= Particle.y
						Particle.emitterName	= Emitter.name
						Particle.Listener		= Emitter.Listener
						Particle.currFXField 	= 0

						-- FOR RANDOM MOTION
						if PType.randomMotionMode ~= 0 then
							Particle.lastRandomMotion   = -1000
							Particle.nextRandomDir	 	= Particle.rotation
							Particle.currRandomDir		= Particle.rotation
						end
						
						-- ADD TO SAME GROUP AS EMITTER
						EmitterParent:insert(Particle)
						
						-- IS PHYSICS PARTICLE?
						if PType.PhysicsMaterial ~= nil then
							Particle.isPhysicsParticle = true
							physics.addBody( Particle, "dynamic", PType.PhysicsMaterial )	
							Particle:setLinearVelocity( Particle.xSpeed*1000, Particle.ySpeed*1000 ) 
							Particle.angularVelocity = PType.rc * 1000
							if (PType.PhysicsProperties) then for n,v in pairs(PType.PhysicsProperties) do Particle[n] = v end end
						else
							Particle.isPhysicsParticle = false
						end

                        PSettings.particlesToEmit = PSettings.particlesToEmit - 1.0
                    end -- /END EMIT PARTICLES
                    
					-- PARTICLE TYPE'S EMISSION FINISHED?
					if now > PSettings.endTime or Emitter.oneShot == true then
                    	PSettings.active = false
                    end
                    
				end -- /END EMISSION STARTED

			end -- /END LOOP ATTACHED PARTICLE TYPES

			-- COUNT ACTIVE PARTICLE TYPES
			local numActive = 0
			for j,pName in ipairs(Emitter.PTypeIndex) do
				if Emitter.PTypeSettings[pName].active == true then numActive = numActive + 1 end
			end
		
			-- EMITTER FINISHED?
			if numActive == 0 then
				if Emitter.loop then 
					StartEmitter(Emitter.name, Emitter.oneShot) 
				else
					StopEmitter (Emitter.name)
					-- AUTODESTROY EMITTER?
					if Emitter.autoDestroy then DeleteEmitter(Emitter.name) end
				end
			end
			
		end -- /END IF EMITTER ACTIVE
		
	end -- /END LOOP EMITTERS
	
	-- ---------------------------------------------------------
	
	V.gParticlesRendered = 0
	
	-- LOOP PARTICLES
	local dx, dy, dst, power, speed
	local maxParticles = V.gMaxParticles
	for i = 1, maxParticles do

		if V.Particles[i]  ~= nil then
			local PType = V.Particles[i].PType
			local P     = V.Particles[i]
			
			V.gParticlesRendered = V.gParticlesRendered + 1


			-- IS NO PHYSICS PARTICLE?
			if P.isPhysicsParticle ~= true then
			
				-- MOVEMENT ----------------------------------------
				P.lastX = P.x
				P.lastY = P.y
				P.x 	= P.x + diffTime * (P.xSpeed * P.emitterScale)
				P.y 	= P.y + diffTime * (P.ySpeed * P.emitterScale)

				-- VELOCITY CHANGE ---------------------------------
				if PType.vc ~= 0 then
					P.xSpeed = P.xSpeed + (diffTime * (P.xSpeed * PType.vc))
					P.ySpeed = P.ySpeed + (diffTime * (P.ySpeed * PType.vc))
				end

				-- RANDOM MOTION -------------------------------
				if PType.randomMotionMode ~= 0 then
					-- LINEAR CHANGE
					if PType.randomMotionMode == 1 then
						if (now - P.lastRandomMotion > PType.randomMotionInterval) then
							P.lastRandomMotion  = now
							P.nextRandomDir		= ((P.nextRandomDir - PType.randomMotionAmount*.5) + V.Rnd()*PType.randomMotionAmount)--%360
							dirAngle			= V.PI-P.nextRandomDir/360*V.PI2
							speed				= V.Sqrt(P.xSpeed*P.xSpeed + P.ySpeed*P.ySpeed)
							P.xSpeed			= V.Sin (dirAngle) * speed
							P.ySpeed			= V.Cos (dirAngle) * speed
						end
					-- SMOOTH CHANGE
					else
						if (now - P.lastRandomMotion > PType.randomMotionInterval) then
							P.lastRandomMotion  = now
							P.nextRandomDir		= ((P.currRandomDir - PType.randomMotionAmount*.5) + V.Rnd()*PType.randomMotionAmount)--%360
						end
						P.currRandomDir = P.currRandomDir + (P.nextRandomDir-P.currRandomDir)/8
						dirAngle		= V.PI-P.currRandomDir/360*V.PI2
						speed			= V.Sqrt(P.xSpeed*P.xSpeed + P.ySpeed*P.ySpeed)
						P.xSpeed		= V.Sin (dirAngle) * speed
						P.ySpeed		= V.Cos (dirAngle) * speed
					end
				end

				-- GRAVITY -----------------------------------------
				P.ySpeed = P.ySpeed + diffTime*P.weight

				-- SCALE CHANGE ------------------------------------
				if now < P.scaleOutTime or PType.so == 0 then	
					P.scale = P.scale + diffTime*PType.si -- SCALE IN
				else
					P.scale = P.scale + diffTime*PType.so -- SCALE OUT
					if P.scale < 0.001 then P.scale = 0.001; P.killTime = now end -- REMOVE WHEN INVISIBLE
				end
				if PType.scaleMax > 0.0 and P.scale > PType.scaleMax then P.scale = PType.scaleMax end
				P.xScale = P.emitterScale * P.scale
				P.yScale = P.xScale

				-- ROTATION ----------------------------------------
				if PType.autoOrientation == false then
					P.rotation = P.rotation + diffTime*(PType.rc)
				else	
					P.rotation = ( V.Atan2( (P.lastY-P.y), (P.lastX-P.x) ) * (180 / V.PI) ) - 90 -- ORIENTATE TO MOVEMENT
				end
				
			else -- IS PHYSICS PARTICLE

				-- RANDOM MOTION -------------------------------
				if PType.randomMotionMode ~= 0 then
					-- LINEAR CHANGE ONLY
					if (now - P.lastRandomMotion > PType.randomMotionInterval) then
						P.lastRandomMotion  = now
						P.nextRandomDir		= ((P.nextRandomDir - PType.randomMotionAmount*.5) + V.Rnd()*PType.randomMotionAmount)--%360
						dirAngle			= V.PI-P.nextRandomDir/360*V.PI2
						local vx, vy 		= P:getLinearVelocity()
						speed				= V.Sqrt(vx*vx + vy*vy)
						P:setLinearVelocity  (V.Sin (dirAngle) * speed, V.Cos (dirAngle) * speed)
					end
				end

			end -- /IS PHYSICS PARTICLE


			-- ALPHA CHANGE ------------------------------------
			if now < P.fadeOutTime or PType.fo == 0 then	
				P.alfa = P.alfa + diffTime*(PType.fi) -- FADE IN
			else
				P.alfa = P.alfa + diffTime*(PType.fo) -- FADE OUT
				if P.alfa < 0.0 then P.alfa = 0; P.killTime = now end -- REMOVE WHEN INVISIBLE
			end
			if P.alfa > 1.0 then P.alfa = 1.0 end
			P.alpha = P.emitterAlpha * P.alfa
			

			-- LOOP FX FIELDS ----------------------------------
			for j,eName in ipairs(V.FXFieldIndex) do
				Field = V.FXFields[eName]
				if Field.enabled and PType.fxID == Field.fxID then
					dx = V.Abs( Field.x - P.x )
					dy = V.Abs( Field.y - P.y )
					dst= (dx*dx + dy*dy)^0.5
					
					-- OUTSIDE FIELD
					if dst > Field.radius then
						-- SEND FX EVENT - JUST MOVED OUT?
						if P.currFXField == Field.uniqueID and Field.Listener ~= nil then
							Field:dispatchEvent( 
								{
								name		= Field.name, 
								phase		= "leave",
								FXField		= Field,
								Particle	= P,
								particleType= PType.name
								} )
							P.currFXField = 0
						end
					
					-- INSIDE FIELD
					else
					
						-- SEND FX EVENTS?
						if Field.Listener ~= nil then
							-- JUST MOVED IN?
							if P.currFXField == 0 then 
								Field:dispatchEvent( 
									{
									name		= Field.name, 
									phase		= "enter",
									FXField		= Field,
									Particle	= P,
									particleType= PType.name
									} )
							end
							P.currFXField = Field.uniqueID
						end
						
						-- IS PHYSICS PARTICLE?
						if P.isPhysicsParticle == true then
							-- ATTRACTOR
							if Field.mode == 0 and dst > 16 then
								power = (1.0-(dst/Field.radius)) * Field.strength
								P:applyForce( (Field.x-P.x)*power, (Field.y-P.y)*power , P.x,P.y )
							-- REJECTOR
							elseif Field.mode == 1 then
								power = (1.0-(dst/Field.radius)) * Field.strength
								P:applyForce( (P.x-Field.x)*power, (P.y-Field.y)*power, P.x,P.y )
							-- PARTICLE KILLER
							elseif Field.mode == 2 then
								P.killTime = now 
							-- SOFT REDIRECTOR
							elseif Field.mode == 3 then
								power    = (1.0-(dst/Field.radius)) * Field.strength
								dirAngle = V.PI-Field.rotation/360*V.PI2
								P:applyForce( V.Sin(dirAngle)*power, V.Cos(dirAngle)*power, P.x,P.y )
							-- HARD REDIRECTOR
							elseif Field.mode == 4 then
								dirAngle = V.PI-Field.rotation/360*V.PI2
								P:setLinearVelocity( V.Sin(dirAngle)*Field.strength, V.Cos(dirAngle)*Field.strength, P.x,P.y )
							end
						
						else
							-- ATTRACTOR
							if Field.mode == 0 and dst > 16 then
								power    = (1.0-(dst/Field.radius)) * (Field.strength/1500)
								P.xSpeed = P.xSpeed + (Field.x-P.x) * power;
								P.ySpeed = P.ySpeed + (Field.y-P.y) * power;
							-- REJECTOR
							elseif Field.mode == 1 then
								local ang= ( V.Atan2( (Field.y-P.y), (Field.x-P.x) ) * (180 / V.PI) ) - 90 
								local dir= V.PI-ang/360*V.PI2
								P.xSpeed = V.Sin(dir) * (V.Abs(P.xSpeed) * PType.bounciness )
								P.ySpeed = V.Cos(dir) * (V.Abs(P.ySpeed) * PType.bounciness )
							-- PARTICLE KILLER
							elseif Field.mode == 2 then 
								P.killTime = now 
							-- SOFT REDIRECTOR
							elseif Field.mode == 3 then
								power    	= (1.0-(dst/Field.radius)) * (Field.strength/1500)
								dirAngle	= V.PI-Field.rotation/360*V.PI2
								P.xSpeed	= P.xSpeed - (P.xSpeed - V.Sin(dirAngle)) * power
								P.ySpeed	= P.ySpeed - (P.ySpeed - V.Cos(dirAngle)) * power
							-- HARD REDIRECTOR
							elseif Field.mode == 4 then
								--local vel = V.Sqrt(P.xSpeed^P.xSpeed + P.ySpeed^P.ySpeed)
								dirAngle	= V.PI-Field.rotation/360*V.PI2
								P.xSpeed	= V.Sin(dirAngle) * (Field.strength/1000)
								P.ySpeed	= V.Cos(dirAngle) * (Field.strength/1000)
							end

							P.x = P.lastX + P.xSpeed*diffTime
							P.y = P.lastY + P.ySpeed*diffTime
						end
					end
				end
			end -- /END LOOP FX FIELDS
			
			-- APPLY COLOR CHANGE?
			if P.setFillColor ~= nil and PType.colorChange ~= 0 then
				P.currColor[1] = P.currColor[1] + PType.ccR*diffTime
				P.currColor[2] = P.currColor[2] + PType.ccG*diffTime
				P.currColor[3] = P.currColor[3] + PType.ccB*diffTime
				if P.currColor[1] > 255 then P.currColor[1] = 255 elseif P.currColor[1] < 0 then P.currColor[1] = 0 end
				if P.currColor[2] > 255 then P.currColor[2] = 255 elseif P.currColor[2] < 0 then P.currColor[2] = 0 end
				if P.currColor[3] > 255 then P.currColor[3] = 255 elseif P.currColor[3] < 0 then P.currColor[3] = 0 end
				P:setFillColor(P.currColor[1], P.currColor[2], P.currColor[3])
			end

			-- SCREEN BORDER CHECK (BOUNCE OR DIE) ------------
			if PType.killOutsideScreen == true or PType.bounceX == true or PType.bounceY == true then
				local x, y = P:localToContent(0, 0)

				if x < 0 or x > V.gScrW then
					if PType.bounceX == true and P.isPhysicsParticle ~= true then 
					P.xSpeed = (PType.bounciness * P.xSpeed) * -1; P.x = P.lastX elseif PType.killOutsideScreen == true then P.killTime = now end
				elseif y < 0 or y > V.gScrH then
					if PType.bounceY == true and P.isPhysicsParticle ~= true then P.ySpeed = (PType.bounciness * P.ySpeed) * -1; P.y = P.lastY elseif PType.killOutsideScreen == true then P.killTime = now end
				end
			end
			
			-- REMOVE PARTICLE?
			if P.killTime <= now then
				-- SEND EVENT?
				if P.Listener ~= nil then
					Runtime:dispatchEvent(
						{ 
						name 			= "particleKilled", 
						x				= P.x,
						y				= P.y,
						rotation		= P.rotation,
						alpha   		= P.alpha,
						scale	  		= P.xScale,
						xSpeed			= P.xSpeed,
						ySpeed			= P.ySpeed,
						typeName		= PType.name,
						particleIndex 	= i,
						emitterName 	= P.emitterName
						}
					)
				end

				-- DELETE PARTICLE
				DeleteParticle(i); 

			end
		
		end -- /END IF PARTICLE EXISTS

	end -- /END LOOP PARTICLES

	-- ---------------------------------------------------------
	
	-- REDUCE MAXPARTICLES, IF POSSIBLE
	local n = V.gMaxParticles
	for i = n,1, -1 do
		V.gMaxParticles = i
		if V.Particles[i] ~= nil then break end
	end

	-- REMOVE CUSTOM EMISSION SHAPE DUMMY GROUP
	if DummyGroup ~= nil then
		DummyGroup:removeSelf()
		DummyGroup = nil
	end

	--collectgarbage("collect")
end
V.Update = Update


----------------------------------------------------------------
-- GET NUMBER OF CURRENTLY ACTIVE PARTICLES
----------------------------------------------------------------
local CountParticles = function ()
	return V.gParticlesRendered
end
V.CountParticles = CountParticles


----------------------------------------------------------------
-- GET MAXIMUM AMOUNT OF PARTICLES (ALSO THE ONES NOT BEING RENDERED)
----------------------------------------------------------------
local GetMaxParticles = function (index)
	return V.gMaxParticles
end
V.GetMaxParticles = GetMaxParticles


----------------------------------------------------------------
-- RETRIEVE HANDLE OF A SINGLE PARTICLE
----------------------------------------------------------------
local GetParticle = function (index)
	return V.Particles[index]
end
V.GetParticle = GetParticle


----------------------------------------------------------------
-- FREEZE PARTICLE SYSTEM (PAUSE)
----------------------------------------------------------------
local Freeze = function ( bySystem )

	if V.gSystemFrozen > 0 then return end
	
	if bySystem == true then V.gSystemFrozen = 2 else V.gSystemFrozen = 1 end
	
	V.gSuspTime = system.getTimer()
	if V.debug then print "--> Particles.Freeze() - PARTICLE SYSTEM FROZEN." end
end
V.Freeze = Freeze

----------------------------------------------------------------
-- UNFREEZE PARTICLE SYSTEM (RESUME)
----------------------------------------------------------------
local WakeUp = function ( bySystem )

	if V.gSystemFrozen == 0 then return end
	if bySystem        == true and V.gSystemFrozen == 1 then return end
	
	V.gSystemFrozen = 0
	V.gLostTime     = V.gLostTime + system.getTimer() - V.gSuspTime
	if V.debug then print ("--> Particles.WakeUp() - PARTICLE SYSTEM RESUMED.") end
end
V.WakeUp = WakeUp


----------------------------------------------------------------
-- SET EMITTER COLOR
----------------------------------------------------------------
local SetEmitterColor = function (r,g,b)

	local i, eName

	V.gEmitterColorR	= r
	V.gEmitterColorG	= g
	V.gEmitterColorB	= b

	for i,eName in ipairs(V.EmitterIndex) do
		V.Emitters[eName]:setColor (V.gEmitterColorR,V.gEmitterColorG,V.gEmitterColorB)
	end
end
V.SetEmitterColor = SetEmitterColor


----------------------------------------------------------------
-- SET REFERENCE TO SPRITE API LOADED BY USER
----------------------------------------------------------------
local UseSpriteAPI = function (SpriteAPI)

	if SpriteAPI == nil then print("--> Particles.UseSpriteAPI() - SPRITE API NOT FOUND!"); return end

	V.gSpriteAPI = SpriteAPI

	if V.debug then print ("--> Particles.UseSpriteAPI() - SPRITE API SET.") end
end
V.UseSpriteAPI = UseSpriteAPI


----------------------------------------------------------------
-- START STOP AUTO-UPDATING
----------------------------------------------------------------
local StartAutoUpdate = function () 
	Runtime:addEventListener( "enterFrame", Update )
end
V.StartAutoUpdate = StartAutoUpdate


----------------------------------------------------------------
-- STOP AUTO-UPDATING
----------------------------------------------------------------
StopAutoUpdate = function ()
	Runtime:removeEventListener( "enterFrame", Update )
end
V.StopAutoUpdate = StopAutoUpdate


----------------------------------------------------------------
-- PRIVATE: APPLICATION PAUSED EVENT
----------------------------------------------------------------
local onSuspend = function ( event )

	if event.type == "applicationSuspend" then
		Freeze(true)
	elseif event.type == "applicationResume" then
		WakeUp(true)
	end
end
V.onSuspend = onSuspend


----------------------------------------------------------------
-- PRIVATE: APPLICATION ROTATE EVENT
----------------------------------------------------------------
local onRotate = function ( event )

end
V.onRotate = onRotate

Runtime:addEventListener( "system"	, onSuspend )
Runtime:addEventListener( "orientation"	, onRotate )

return V