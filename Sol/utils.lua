module ('utils', package.seeall)

function showFps()
        local prevTime = 0
        local curTime = 0
        local dt = 0       
        local fps = 50
        local mem = 0
              
        local underlay = display.newRoundedRect(0, 0, 300, 20, 12)   
        underlay.x = 240
        underlay.y = 11
        underlay:setFillColor(0, 0, 0, 128)             
        local displayInfo = display.newText("FPS: " .. fps .. " - Memory: ".. mem .. "mb", 20, 0, native.systemFontBold, 16)
        
        local function updateText()
                curTime = system.getTimer()
                dt = curTime - prevTime
                prevTime = curTime
                fps = math.floor(1000 / dt)
                mem = system.getInfo("textureMemoryUsed") / 1000000
                
                --Limit fps range to avoid the "fake" reports
                if fps > 60 then
                        fps = 60
                end
                
                displayInfo.text = "FPS: " .. fps .. " - Memory: ".. string.sub(mem, 1, string.len(mem) - 4) .. "mb"
                underlay:toFront()
                displayInfo:toFront()
        end
        
	Runtime:addEventListener("enterFrame", updateText)
end


function showScreenSize()
	print('Screen width: ', display.contentWidth);
	print('Screen height: ', display.contentHeight);	
	print('Screen top: ', display.screenOriginY);
	print('Screen bottom: ', display.viewableContentHeight + display.screenOriginY);
	print('Screen left: ', display.screenOriginX);
	print('Screen right: ', display.viewableContentWidth + display.screenOriginX);
end


function sign(x)
  return (x<0 and -1) or 1
end