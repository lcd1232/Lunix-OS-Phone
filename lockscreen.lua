local month =  {"January", "February", "March", "April" , "May", "June", "July", "August", "September", "October", "November", "December"}
local months = {"Январь",  "Февраль" , "Март" , "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь" , "Октябрь", "Ноябрь"  , "Декабрь" }

local clickers = false

local elementTable={}
addEventHandler("onClientResourceStart", root, function(res)
    if res ~= getThisResource() then return false end
    
    local w, h = getPhoneSize()
    lockscreen = guiCreateStaticImage(0, 0, w, h, "images/element.png", false, getDesktop())
    guiSetProperty(lockscreen, "ImageColours", "tl:BB111111 tr:BB111111 bl:BB111111 br:BB111111")
    
    timelockscreen = guiCreateLabel(0, 20, w, 100, "12:30", false, lockscreen)
    guiLabelSetHorizontalAlign(timelockscreen, "center")
    guiLabelSetVerticalAlign(timelockscreen, "bottom")
    guiSetFont(timelockscreen, guiCreateFont("fonts/bold.ttf", 50))
    
    datelockscreen = guiCreateLabel(0, 110, w, 20, "23.12.2014", false, lockscreen)
    guiLabelSetHorizontalAlign(datelockscreen, "center")
    guiSetFont(datelockscreen, guiCreateFont("fonts/light.ttf", 12))
    
    swipeleft = guiCreateLabel(50, h-20, w-100, 20, "Swipe to unlock", false, lockscreen)
    guiLabelSetHorizontalAlign(swipeleft, "center")
    guiSetFont(swipeleft, guiCreateFont("fonts/thin.ttf", 10))
    
    table.insert(elementTable, lockscreen)
    table.insert(elementTable, timelockscreen)
    table.insert(elementTable, datelockscreen)
    table.insert(elementTable, swipeleft)
    
    addEventHandler("onClientGUIMouseDown", lockscreen, function(Button, ScrollX, ScrollY)
            
        local booled = false
        for i,v in ipairs(elementTable) do if source == v then booled = true break end end
        if not booled then return false end
        
        if Button ~= "left" then return 1 end
            
        clickers = true
        
        local scrollPositionX = guiGetPosition(lockscreen, false)
        newPositions = ScrollX-scrollPositionX
        scrollCursor = ScrollX
    end)
            
    addEventHandler("onClientGUIMouseUp", root, function()
            
        local booled = false
        for i,v in ipairs(elementTable) do if source == v then booled = true break end end
        if not booled then return false end
        
        if not clickers then return 1 end     
        
        local getPosX = guiGetPosition(lockscreen, false)
        if getPosX < 150 then showLockScreen()
        else closeLockScreen() end
        
        clickers = false
    end)
    
    addEventHandler("onClientCursorMove", root, function(_, _, cursorPosX, cursorPosY)
        
        if not clickers then return 1; end
        
        local phoneX, phoneY = getPhonePosition()
        local phonew, phoneh = getPhoneSize()
        local screenX, screenY = getScreenPosition()
        local notX, notY = guiGetPosition(lockscreen, false)
        local notW, notH = guiGetSize(lockscreen, false)
            
        local findPosition = cursorPosX-newPositions
        
        if findPosition < 0 then
            findPosition = 0 
            setCursorPosition(scrollCursor, cursorPosY)
        end 
        
        if cursorPosX > (phoneX+screenX+notW)-15 then
            findPosition = (phoneX+screenX+notW)-15
            setCursorPosition((phoneX+screenX+notW)-15, cursorPosY)
        end
        
        if cursorPosY < phoneY+screenY+notY+40 then setCursorPosition(cursorPosX, phoneY+screenY+notY+40) end
        if cursorPosY > (phoneY+screenY+notY+40+notH)-15 then setCursorPosition(cursorPosX, (phoneY+screenY+notY+40+notH)-15) end
        
        guiSetPosition(lockscreen, findPosition, notY, false)
    end)
end)
addEventHandler("onClientRender", root, function()
    if not guiGetVisible(lockscreen) then return false end
    guiSetText(timelockscreen, string.format("%.2i:%.2i", getRealTime().hour, getRealTime().minute))
    guiSetText(datelockscreen, string.format("%s %i, %i", month[getRealTime().month+1], getRealTime().monthday, getRealTime().year+1900))
end)

local moveTimer
function showLockScreen()
    if not isElement(lockscreen) then return false end
    if isTimer(moveTimer) then return false end
    
    setEnabledNotificationPanel(false)
    
    guiSetVisible(lockscreen, true)
    local posX, posY = guiGetPosition(lockscreen, false)
    
    local getMod = math.fmod(posX, 40)
    local timerNumber =  math.abs( (posX-getMod) /40 )+1 
    
    local num = 0
    moveTimer = setTimer(function()
        local newPosX = guiGetPosition(lockscreen, false)
        if newPosX == 0 then return 1 end
        if newPosX < 0 then newPosX = 0 end
        if newPosX > 0 then
            if num == 0 then
                num = 1
                guiSetPosition(lockscreen, newPosX-getMod, posY, false)
            else
                guiSetPosition(lockscreen, newPosX-40, posY, false)
            end
        end
    end, 50, timerNumber)
end

function closeLockScreen()
    if not isElement(lockscreen) then return false end
    if isTimer(moveTimer) then return false end
    setEnabledNotificationPanel(true)
    
    local numeric = 0
    moveTimer = setTimer(function()
        numeric = numeric+1
        local x, y = guiGetPosition(lockscreen, false)
        guiSetPosition(lockscreen, x+40, y, false)
        if numeric >= 16 then guiSetVisible(lockscreen, false) end
    end, 50, 8)
    
    triggerEvent("onClientCloseLockScreen", localPlayer)
    
end

function getLockScreen()
    return lockscreen
end
function addLockScreenElement(element)
    if not isElement(element) then return false end
    table.insert(elementTable, element)
end