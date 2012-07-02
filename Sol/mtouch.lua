-----------------------------------------------------------------------------------------
--
-- mtouch.lua
-- http://dantes-andreea.blogspot.com/2011/07/corona-lua-multi-touch-pinch-zoom.html
--
-----------------------------------------------------------------------------------------

module(..., package.seeall)
-- activate multitouch
system.activate( "multitouch" )

-- current touches
-- touchesPinch = {}
-- local touches = {}

-- math helpers
local sqrt         = math.sqrt
local abs     = math.abs
-- last zoom distance - I use this to compare with current distance
-- if its smaller then zoom out, else  zoom in
local lastDistance = 0
local zoomObject   = nil      --the zoom object
local OnZoomIn     = nil      --the zoom in event
local OnZoomOut    = nil      --the zoom out event
--fictive touch
local fictiveTouch = {}
fictiveTouch.id = "QHHJGL10"

-----------------------------------------------
-- counts a dictionary
-----------------------------------------------
local function CountDictionary(dict)
    local ret = 0
    for k, v in pairs(dict) do
        ret = ret + 1
    end
    
    return ret
end

-----------------------------------------------
-- returns an element at some index in a dictionary
-----------------------------------------------
local function GetDictElAtIndex( dict, index )
 local temp = 0
 local ret  = nil
 for k, v in pairs(dict) do
  if( temp == index ) then
   ret   = v
   break
  end
  temp   = temp + 1
 end
 return ret
end

-----------------------------------------------
-- update x and y for a specific touch-event
-----------------------------------------------
local function UpdateTouch( event )
    local id  = event.id
    local obj = event.target
    local  x  = event.x
    local  y  = event.y
    
    if touchesPinch[id] then
        touchesPinch[id].x = x
        touchesPinch[id].y = y
    end
end

-----------------------------------------------
-- calculate the distance between two touches 
-----------------------------------------------
local function DistanceBetween2T( t1, t2 )
    local ret = 0
    local deltax = t2.x - t1.x
    local deltay = t2.y - t1.y
    ret          = sqrt( deltax * deltax + deltay * deltay )
    return ret
end
-----------------------------------------------
-- touch listener
-----------------------------------------------
function on_touch( event )
    local ret = false
    local t = event.target

    if event.phase == "began" then
        showInfo(nil)

        --register this touch
        touchesPinch[ event.id ] = event

        if( CountDictionary(touchesPinch) >= 2 ) then
            oneTouchBegan = false
            display.getCurrentStage():setFocus( t )
        else
            oneTouchBegan = true
            local sky = groupSky.shine
            groupX, groupY = group.x, group.y
            sky.x0, sky.y0 = sky.x, sky.y
        end
    elseif event.phase == "moved" then
        UpdateTouch(event)
        
        --verify if i have at least 2 touches
        if( CountDictionary(touchesPinch) >= 2 ) then
            oneTouchBegan = false
            zoomObject.touching = true
            
            --gets the first 2 touches and calculate the distance between them
            local touch1 = GetDictElAtIndex( touchesPinch, 0 )
            local touch2 = GetDictElAtIndex( touchesPinch, 1 )
            local dist   = DistanceBetween2T( touch1, touch2 )
            --
            local args        = {}
            args.distance     = dist
            args.lastdistance = lastDistance
            args.difference   = abs( lastDistance - dist )
            args.touch1       = touch1
            args.touch2       = touch2
            
            if lastDistance ~= -1 then
                if dist < lastDistance then 
                    --zoom out
                    if OnZoomOut ~= nil then OnZoomOut( args ) end
                else
                    --zoom in
                    if OnZoomIn  ~= nil then  OnZoomIn( args ) end
                end
                ret = true
            end
   
            --save the lastdistance
            lastDistance = dist
        elseif oneTouchBegan then
            local e = event
            local sky = groupSky.shine
            group.x = groupX + (e.x - e.xStart)
            group.y = groupY + (e.y - e.yStart)

            sky.x = sky.x0 + (e.x - e.xStart) / 5
            sky.y = sky.y0 + (e.y - e.yStart) / 10

            groupSky.sky.x = sky.x0 + (e.x - e.xStart) / 10
            groupSky.sky.y = sky.y0 + (e.y - e.yStart) / 20

            if (sky.x > sky.width/2) then
                sky.x = sky.width/2
            end
            if (sky.x < screenW-sky.width/2) then
                sky.x = screenW-sky.width/2
            end
            if (sky.y > sky.height/2) then
                sky.y = sky.height/2
            end
            if (sky.y < screenH-sky.height/2) then
                sky.y = screenH-sky.height/2
            end
        end
 
    elseif event.phase == "ended" or event.phase == "cancelled" then
        --remove this touch from list
        touchesPinch[ event.id ]  = nil
        lastDistance    = -1
        zoomObject.touching = false

        if( CountDictionary(touchesPinch) < 2 ) then
            display.getCurrentStage():setFocus( nil )
            -- return true
        end

        groupX, groupY = 0, 0
    end

    return ret
end

-----------------------------------------------
-- properties
-----------------------------------------------
function setZoomObject( obj )
 zoomObject          = obj
 zoomObject.touching = false
 -- register table listener
 zoomObject:addEventListener( "touch", on_touch )
end


-----------------------------------------------
-- returns current zoom object
-----------------------------------------------
function getZoomObject() 
 return zoomObject
end

-----------------------------------------------
-- returns the number of current touches
-----------------------------------------------
function getNrTouches() 
 return CountDictionary(touches)
end

-----------------------------------------------
-- sets the zoomin event function
-----------------------------------------------
function setOnZoomIn( event )
 OnZoomIn = event
end

-----------------------------------------------
-- sets the zoomout event function
-----------------------------------------------
function setOnZoomOut( event )
 OnZoomOut = event
end

-----------------------------------------------
-- for the simulator: create a fictive touch
-----------------------------------------------
function setFictiveSimulatorTouch( x, y)
 fictiveTouch.x = x; fictiveTouch.y = y
 touches[ fictiveTouch.id ] = fictiveTouch
 fictiveTouch.rect = display.newRect( fictiveTouch.x, fictiveTouch.y, 20, 20 )
end

-----------------------------------------------
-- for the simulator: removes a fictive touch
-----------------------------------------------
function removeFictiveSimulatorTouch()
 touches[ fictiveTouch.id ] = nil
 fictiveTouch.rect:removeSelf()
end

-----------------------------------------------
-- clean me
-----------------------------------------------
function clean()
 zoomObject:removeEventListener( "touch", on_touch )
end