local Particles = require("lib_particle_candy")

function initClouds()
	local screenW 	= display.contentWidth
	local screenH 	= display.contentHeight

	-- CREATE EMITTER (NAME, SCREENW, SCREENH, ROTATION, ISVISIBLE, LOOP)
	Particles.CreateEmitter("E1", 0,screenH/2, -90, true, true)

	-- FOR ROTATION
	local Group = display.newGroup()
	Group:translate(screenW*.5, screenH*.5)
	Group:insert(Particles.GetEmitter("E1"))
	Group.alpha = 0.7

	-- DEFINE PARTICLE TYPES
	Particles.CreateParticleType ("Stars1", 
		{
		imagePath		= "bg/stars1.png",
		imageWidth		= 96,	
		imageHeight		= 96,	
		velocityStart		= 200,	
		killOutsideScreen	= false,	 
		lifeTime		= 5000,  
		
		scaleStart		= 0.15,
		scaleVariation		= 0.15,
		scaleInSpeed		= 2.0,

		alphaStart		= 0,		
		fadeInSpeed		= 2.0,	
		fadeOutSpeed		= -0.7,	
		fadeOutDelay		= 1250,
		
		directionVariation	= 360,
		blendMode		= "add",
		autoOrientation 	= false,	
		rotationVariation	= 360,
		
		colorStart		= { 255,255,255 },
		colorChange		= { 50,50,50 },
		} )

	Particles.CreateParticleType ("Stars2", 
		{
		imagePath		= "bg/stars2.png",
		imageWidth		= 128,	
		imageHeight		= 128,	
		velocityStart		= 2*75,	
		killOutsideScreen	= false,	 
		lifeTime		= 5000,  
		
		scaleStart		= 0.15,
		scaleVariation		= 0.15,
		scaleInSpeed		= 2.0,

		alphaStart		= 0,		
		fadeInSpeed		= 2.0,	
		fadeOutSpeed		= -0.7,	
		fadeOutDelay		= 1250,
		
		directionVariation	= 360,
		blendMode		= "add",
		autoOrientation 	= false,	
		rotationVariation	= 360,
		
		colorStart		= { 255,255,255 },
		colorChange		= { 50,50,50 },
		} )

	Particles.CreateParticleType ("Cloud", 
		{
		imagePath		= "bg/cloud.png",
		imageWidth		= 128,	
		imageHeight		= 128,	
		velocityStart		= 2*75,	
		killOutsideScreen	= false,	 
		lifeTime		= 5000,  
		
		scaleStart		= 0.15,
		scaleVariation		= 0.15,
		scaleInSpeed		= 2.0,

		alphaStart		= 0,		
		fadeInSpeed		= 0.3,	
		fadeOutSpeed		= -0.2,	
		fadeOutDelay		= 2500,
		
		directionVariation	= 360,
		blendMode		= "add",
		autoOrientation 	= false,	
		rotationVariation	= 360,
		
		colorStart		= { 115,100,125 },
		} )

	local k = 1

	-- FEED EMITTER (EMITTER NAME, PARTICLE TYPE NAME, EMISSION RATE, DURATION, DELAY)
	Particles.AttachParticleType("E1", "Stars1", 9*k, 99999,0) 
	Particles.AttachParticleType("E1", "Stars2", 3*k, 99999,0) 
	Particles.AttachParticleType("E1", "Cloud" , 2*k, 99999,0) 

	-- TRIGGER THE EMITTER
	Particles.StartEmitter("E1")

	return Group
end

