-----------------------------------------------------------------------------------------
--
-- events.lua
--
-----------------------------------------------------------------------------------------

local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

local baseImpulse = 1
local maxImpulseMoveSize = 100
local rand = math.random

---------------------------------------
function addParticle( e )
	local r = rand(10,40)
	local xi = (2 - rand(4)) / 200
	local yi = (2 - rand(4)) / 200
	local i = rand(1,3)

	local p = display.newImageRect("i/p"..i..".png", r, r*1.3)
	p.x, p.y = rand(10, screenW-40), rand(10, screenH-40)
	p.rotation = rand(60)
	p:setFillColor(rand(100, 200))
	p.name = "particle"
	
	physics.addBody(p, {bounce=0.2, friction=0, radius=r/2})
	
	group:insert(p)
	p:applyLinearImpulse(xi, yi, p.x, p.y)
end

---------------------------------------

local arrows = {}

function moveAmeba( e )
	local t = e.target
	local phase = e.phase

	local arrow = arrows[e.id]

	if phase == 'began' then
		display.getCurrentStage():setFocus( t, e.id )
		t.isFocus = true
		-- print(t:getLinearVelocity())
        t:setLinearVelocity(0,0)

        arrows[e.id] = nil

    elseif t.isFocus then

    	local dx = e.x-e.xStart
	    local dy = e.y-e.yStart

		if arrow then
			arrow:removeSelf()
		end

		if "moved" == phase then
			-- TODO: draw arrow end
			-- TODO: limit arrow length
			-- TODO: fix target center
			local arrow = display.newLine(t.x,t.y, e.xStart + dx, e.yStart + dy )
			arrow.width = 3
			arrows[e.id] = arrow
		
		elseif "ended" == phase or "cancelled" == phase then

			arrows[e.id] = nil

			t.isFocus = false
			display.getCurrentStage():setFocus( t, e.id )
	    	
	        local length = math.sqrt(dx*dx + dy*dy)
	        if length > 0 then
		        local xI = dx / length;
		        local yI = dy / length;

		        if length > maxImpulseMoveSize then
		        	length = maxImpulseMoveSize
		        end
		        local k = length / maxImpulseMoveSize * baseImpulse

		    	t:applyLinearImpulse(xI*k, yI*k, t.x, t.y)
	        end
		end
    end
end

---------------------------------------
function collisionAmeba( self, e )
	if(e.phase == 'began') then
		local t = e.target
		local o = e.other

		if o.name == "particle" then
			if t.name == "player" then
				t.score = t.score + 1
				t.label.text = t.label.prefix .. t.score

				-- hide 'eaten' particle
				o.alpha = 0
			end
		end
	end
end

---------------------------------------
function frameHandler( e )
	for i = group.numChildren, 1, -1 do
		local g = group[i]
		-- Remove deleted particles
		if g.alpha == 0 then
			g:removeSelf()
		end
	end
end