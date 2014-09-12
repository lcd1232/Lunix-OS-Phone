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
        guiBringToFront(lockscreen)
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
        guiBringToFront(lockscreen)
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
        
        if notX < phonew-100 then guiSetAlpha(lockscreen, 1) end
        if notX >= phonew-100 and notX < phonew-90 then guiSetAlpha(lockscreen, 0.9) end
        if notX >= phonew-90 and notX < phonew-80 then guiSetAlpha(lockscreen, 0.8) end
        if notX >= phonew-80 and notX < phonew-70 then guiSetAlpha(lockscreen, 0.7) end
        if notX >= phonew-70 and notX < phonew-60 then guiSetAlpha(lockscreen, 0.6) end
        if notX >= phonew-60 and notX < phonew-50 then guiSetAlpha(lockscreen, 0.5) end
        if notX >= phonew-50 and notX < phonew-40 then guiSetAlpha(lockscreen, 0.4) end
        if notX >= phonew-40 and notX < phonew-30 then guiSetAlpha(lockscreen, 0.3) end
        if notX >= phonew-30 and notX < phonew-20 then guiSetAlpha(lockscreen, 0.2) end
        if notX >= phonew-20 and notX < phonew-10 then guiSetAlpha(lockscreen, 0.1) end
        if notX >= phonew-10 then guiSetAlpha(lockscreen, 0) end
        
        if cursorPosX > (phoneX+screenX+notW)-15 then
            findPosition = (phoneX+screenX+notW)-15
            setCursorPosition((phoneX+screenX+notW)-15, cursorPosY)
        end
        
        guiBringToFront(lockscreen)
        
        if cursorPosY < phoneY+screenY+notY+40 then setCursorPosition(cursorPosX, phoneY+screenY+notY+40) end
        if cursorPosY > (phoneY+screenY+notY+40+notH)-15 then setCursorPosition(cursorPosX, (phoneY+screenY+notY+40+notH)-15) end
        
        guiSetPosition(lockscreen, findPosition, notY, false)
    end)
end)
--[[addEventHandler("onClientRender", root, function()
    if not guiGetVisible(lockscreen) then return false end
    guiSetText(timelockscreen, string.format("%.2i:%.2i", getRealTime().hour, getRealTime().minute))
    guiSetText(datelockscreen, string.format("%s %i, %i", month[getRealTime().month+1], getRealTime().monthday, getRealTime().year+1900))
    end)]]

local moveTimer = false
local getOpeningMod = {}
function showLockScreen()
    if moveTimer then return false end
    
    setEnabledNotificationPanel(false)
    
    local phonew = getPhoneSize()
    
    guiSetVisible(lockscreen, true)
    local posX = guiGetPosition(lockscreen, false)
    
    getOpeningMod = {math.fmod(posX, 10), phonew}
    
    guiBringToFront(lockscreen)
    
    moveTimer = true
end

local num = 0
addEventHandler("onClientRender", root, 
    function()
        if not moveTimer then return false end
        
        local newPosX, posY = guiGetPosition(lockscreen, false)
        if newPosX <= 0 then 
            guiSetPosition(lockscreen, 0, posY, false)
            moveTimer = false 
            return 1 
        end
        if newPosX > 0 then
            if num == 0 then
                num = 1
                guiSetPosition(lockscreen, newPosX-getOpeningMod[1], posY, false)
            else
                guiSetPosition(lockscreen, newPosX-10, posY, false)
            end
        
            if newPosX < getOpeningMod[2]-100 then guiSetAlpha(lockscreen, 1) end
            if newPosX >= getOpeningMod[2]-100 and newPosX < getOpeningMod[2]-90 then guiSetAlpha(lockscreen, 0.9) end
            if newPosX >= getOpeningMod[2]-90 and newPosX < getOpeningMod[2]-80 then guiSetAlpha(lockscreen, 0.8) end
            if newPosX >= getOpeningMod[2]-80 and newPosX < getOpeningMod[2]-70 then guiSetAlpha(lockscreen, 0.7) end
            if newPosX >= getOpeningMod[2]-70 and newPosX < getOpeningMod[2]-60 then guiSetAlpha(lockscreen, 0.6) end
            if newPosX >= getOpeningMod[2]-60 and newPosX < getOpeningMod[2]-50 then guiSetAlpha(lockscreen, 0.5) end
            if newPosX >= getOpeningMod[2]-50 and newPosX < getOpeningMod[2]-40 then guiSetAlpha(lockscreen, 0.4) end
            if newPosX >= getOpeningMod[2]-40 and newPosX < getOpeningMod[2]-30 then guiSetAlpha(lockscreen, 0.3) end
            if newPosX >= getOpeningMod[2]-30 and newPosX < getOpeningMod[2]-20 then guiSetAlpha(lockscreen, 0.2) end
            if newPosX >= getOpeningMod[2]-20 and newPosX < getOpeningMod[2]-10 then guiSetAlpha(lockscreen, 0.1) end
            if newPosX >= getOpeningMod[2]-10 then guiSetAlpha(lockscreen, 0) end
            
        end
<<<<<<< HEAD
    end)
=======
    end, 50, timerNumber)
    guiBringToFront(lockscreen)
end
>>>>>>> f16b9bd255bdc3c9569cc35c97970dd2aa0d5fe1

local moveTimerOpen = false
function closeLockScreen()
    if not isElement(lockscreen) then return false end
    if moveTimerOpen then return false end
    
    setEnabledNotificationPanel(true)
    
    triggerEvent("onClientCloseLockScreen", localPlayer)
    
    moveTimerOpen = true
    
end

local phonew = getPhoneSize()
addEventHandler("onClientRender", root, 
    function()
        if not moveTimerOpen then return false end
        local x, y = guiGetPosition(lockscreen, false)
        guiSetPosition(lockscreen, x+10, y, false)
        if x > phonew then moveTimerOpen = false guiSetVisible(lockscreen, false) end
        
        if x < phonew-100 then guiSetAlpha(lockscreen, 1) end
        if x >= phonew-100 and x < phonew-90 then guiSetAlpha(lockscreen, 0.9) end
        if x >= phonew-90 and x < phonew-80 then guiSetAlpha(lockscreen, 0.8) end
        if x >= phonew-80 and x < phonew-70 then guiSetAlpha(lockscreen, 0.7) end
        if x >= phonew-70 and x < phonew-60 then guiSetAlpha(lockscreen, 0.6) end
        if x >= phonew-60 and x < phonew-50 then guiSetAlpha(lockscreen, 0.5) end
        if x >= phonew-50 and x < phonew-40 then guiSetAlpha(lockscreen, 0.4) end
        if x >= phonew-40 and x < phonew-30 then guiSetAlpha(lockscreen, 0.3) end
        if x >= phonew-30 and x < phonew-20 then guiSetAlpha(lockscreen, 0.2) end
        if x >= phonew-20 and x < phonew-10 then guiSetAlpha(lockscreen, 0.1) end
        if x >= phonew-10 then guiSetAlpha(lockscreen, 0) end
    end)

function getLockScreen()
    return lockscreen
end
function addLockScreenElement(element)
    if not isElement(element) then return false end
    table.insert(elementTable, element)
end
