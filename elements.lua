local windowCount = 0
local phoneWindow={}
local phoneWindowStatusbarType={}
local phoneWindowStatusbarBy={}

local windowCloser = {}
local windowOpener = {}
function createPhoneWindow(colortop, colbottom, enablestatusbar, statusbartype)
    if enablestatusbar == nil or (enablestatusbar ~= true and enablestatusbar ~= false) then enablestatusbar = true end
    if statusbartype == nil or (statusbartype ~= "desktop" and statusbartype ~= "app") then statusbartype = "app" end
    
    if not colortop or type(colortop) == "userdata" then colortop = tocolor(80, 80, 80, 255) end 
    if not colbottom or type(colbottom) == "userdata" then colbottom = tocolor(80, 80, 80, 255) end 
    
    local w, h = getPhoneSize()
    windowCount = windowCount+1
    phoneWindow[windowCount] = guiCreateStaticImage(0, 0, w, h, "images/element.png", false, getDesktop())
    phoneWindowStatusbarType[windowCount] = statusbartype
    phoneWindowStatusbarBy[windowCount] = enablestatusbar
    
    colortop = string.format("%x", colortop)
    colbottom = string.format("%x", colbottom)
    guiSetProperty(phoneWindow[windowCount], "ImageColours", "tl:"..colortop.." tr:"..colortop.." bl:"..colbottom.." br:"..colbottom.."")
    
    --guiSetVisible(getStatusbar(), enablestatusbar)
    --desktopNotbarType(statusbartype)
    
    --guiBringToFront(getStatusbar())
    guiBringToFront(getNotbar()) 
    guiBringToFront(getNotbarMover())
    
    guiSetVisible(phoneWindow[windowCount], false)
    windowCloser[windowCount] = false
    windowOpener[windowCount] = false
    
    return phoneWindow[windowCount], windowCount
end
local settingsPanel = {}

function hideAllWindows()
    closeTopbar()
    for i = 1, windowCount+1 do
        if not isElement(phoneWindow[i]) then return false end
        windowCloser[i] = true
        desktopNotbarType("desktop")
        guiSetVisible(getStatusbar(), true)
    end
end

local windowX = {}
local windowY = {}
local phoneWid, phoneHei = getPhoneSize()

function showWindow(id)
    if not isElement(phoneWindow[id]) then return false end
    if windowCloser[id] then return false end
    
    desktopNotbarType(phoneWindowStatusbarType[id])
    windowX[id], windowY[id] = guiGetPosition(phoneWindow[id], false)
    guiSetVisible(getStatusbar(), phoneWindowStatusbarBy[id])
    guiSetPosition(phoneWindow[id], windowX[id], phoneHei, false)
    guiSetVisible(phoneWindow[id], true)
    closeTopbar()
    windowOpener[windowCount] = true
end

addEventHandler("onClientRender", root, function()
    
    guiBringToFront(getStatusbar())
    guiBringToFront(getNotbar()) 
    guiBringToFront(getNotbarMover())
    
    for i = 0, table.maxn(windowOpener) do 
        if windowOpener[i] == true then 
            local x, y = guiGetPosition(phoneWindow[i], false)
        
            if y < windowY[i] then 
                guiSetPosition(phoneWindow[i], windowX[i], windowY[i], false)
                windowOpener[i] = false
                cancelEvent()
                return 1 
            end
            guiSetPosition(phoneWindow[i], x, y-25, false)
        end 
    end
end)

function hideWindow(id)
    if not isElement(phoneWindow[id]) then return false end
    if windowOpener[id] then return false end
    
    desktopNotbarType("desktop")
    windowX[id], windowY[id] = guiGetPosition(phoneWindow[id], false)
    guiSetVisible(getStatusbar(), true)
    closeTopbar()
    windowCloser[id] = true
end

addEventHandler("onClientRender", root, function()
    for i = 0, table.maxn(windowCloser) do  
        if windowCloser[i] == true then 
            local x, y = guiGetPosition(phoneWindow[i], false)
    
            guiBringToFront(getStatusbar())
            guiBringToFront(getNotbar()) 
            guiBringToFront(getNotbarMover())
        
            if y > phoneHei then 
                guiSetVisible(phoneWindow[i], false)
                guiSetPosition(phoneWindow[i], windowX[i], windowY[i], false)
                windowCloser[i] = false
                cancelEvent()
                return 1 
            end
            guiSetPosition(phoneWindow[i], x, y+30, false)
        end 
    end
end)

local switchCount = 0
local phoneSwitcher={}
local enablingSwitch={}
local timer={}
function createSwitcher(x, y, enabled, parent)
    if not x or not tonumber(x) then x = 50 end
    if not y or not tonumber(y) then y = 50 end
    if enabled == nil or (enabled ~= false and enabled ~= true) then enabled = false end
    if parent == nil or not isElement(parent) then parent = getDesktop() end
    
    switchCount = switchCount+1
    phoneSwitcher[switchCount]={}
    phoneSwitcher[switchCount]["Switcher"] = guiCreateStaticImage(x, y, 50, 20, "images/switcher.png", false, parent)
    phoneSwitcher[switchCount]["Switch"] = guiCreateStaticImage(1, 1, 18, 18, "images/switch.png", false, phoneSwitcher[switchCount]["Switcher"])
    enablingSwitch[phoneSwitcher[switchCount]["Switcher"] ] = enabled
    --guiSetProperty(phoneSwitcher[switchCount]["Switch"], "ImageColours", "tl:FFAAAAAA tr:FFAAAAAA bl:FFAAAAAA br:FFAAAAAA")
    if enabled == true then guiSetPosition(phoneSwitcher[switchCount]["Switch"], 31, 1, false)
    else guiSetPosition(phoneSwitcher[switchCount]["Switch"], 1, 1, false) end
     
    switching(switchCount)
    
    return switchCount
end

function getSwitcherEnabled(id)
    if not isElement(phoneSwitcher[id]["Switcher"]) then return nil end
    return enablingSwitch[phoneSwitcher[id]["Switcher"] ]
end

function switching(id)
    addEventHandler("onClientGUIClick", phoneSwitcher[id]["Switcher"],
        function()
            if enablingSwitch[phoneSwitcher[id]["Switcher"] ] == true then
            
                if isTimer(timer[id]) then return 1 end
                enablingSwitch[phoneSwitcher[id]["Switcher"] ] = false
                
                timer[id] = setTimer(function()
                
                    local x = guiGetPosition(phoneSwitcher[id]["Switch"], false)
                    guiSetPosition(phoneSwitcher[id]["Switch"], x-5, 1, false)
                    --guiSetProperty(phoneSwitcher[id]["Switcher"], "ImageColours", "tl:F7AA0000 tr:F7AA0000 bl:F7AA0000 br:F7AA0000")
                    
                end, 50, 6)
                
                triggerEvent("onClientDisableSwitcher", localPlayer, id)
                
            elseif enablingSwitch[phoneSwitcher[id]["Switcher"] ] == false then
            
                if isTimer(timer[id]) then return 1 end
                enablingSwitch[phoneSwitcher[id]["Switcher"] ] = true
                
                timer[id] = setTimer(function()
                
                    local x = guiGetPosition(phoneSwitcher[id]["Switch"], false)
                    guiSetPosition(phoneSwitcher[id]["Switch"], x+5, 1, false)
                    --guiSetProperty(phoneSwitcher[id]["Switcher"], "ImageColours", "tl:F700AA00 tr:F700AA00 bl:F700AA00 br:F700AA00")
                    
                end, 50, 6)
                
                triggerEvent("onClientEnableSwitcher", localPlayer, id)
                
            end
        end, false)
    addEventHandler("onClientGUIClick", phoneSwitcher[id]["Switch"],
        function()
            if enablingSwitch[phoneSwitcher[id]["Switcher"] ] == true then
            
                if isTimer(timer[id]) then return 1 end
                enablingSwitch[phoneSwitcher[id]["Switcher"] ] = false
                
                timer[id] = setTimer(function()
                
                    local x = guiGetPosition(phoneSwitcher[id]["Switch"], false)
                    guiSetPosition(phoneSwitcher[id]["Switch"], x-5, 1, false)
                    --guiSetProperty(phoneSwitcher[id]["Switcher"], "ImageColours", "tl:F7AA0000 tr:F7AA0000 bl:F7AA0000 br:F7AA0000")
                    
                end, 50, 6)
                
                triggerEvent("onClientDisableSwitcher", localPlayer, id)
                
            elseif enablingSwitch[phoneSwitcher[id]["Switcher"] ] == false then
            
                if isTimer(timer[id]) then return 1 end
                enablingSwitch[phoneSwitcher[id]["Switcher"] ] = true
                
                timer[id] = setTimer(function()
                
                    local x = guiGetPosition(phoneSwitcher[id]["Switch"], false)
                    guiSetPosition(phoneSwitcher[id]["Switch"], x+5, 1, false)
                    --guiSetProperty(phoneSwitcher[id]["Switcher"], "ImageColours", "tl:F700AA00 tr:F700AA00 bl:F700AA00 br:F700AA00")
                    
                end, 50, 6)
                
                triggerEvent("onClientEnableSwitcher", localPlayer, id)
                
            end
        end, false)
end

local Notification={}    
local closeNotifi={}
local textNotification={}
local titleNotification={}
local iconNotificate={}
local allNotifications = {}

function addNotification(title, text, height, icon, red, green, blue, movable)
    if not red then red = 100 end
    if not green then green = 100 end
    if not blue then blue = 100 end
    if not height or not tonumber(height) or height < 50 then height = 50 end
    if movable == nil or (movable ~= false and movable ~= true) then movable = true end
    local IDentify = 0
    
    for i = 0, table.maxn(allNotifications)+1 do 
        IDentify = IDentify+1
        if isElement(Notification[i]) then
        
            local posX, poxY = guiGetPosition(Notification[i], false)
            guiSetPosition(Notification[i], posX, poxY+height+1, false)
            
        end
    end
    
    
    local w = getPhoneSize()
    
    Notification[IDentify] = guiCreateStaticImage(0, 0, w, height, "images/element.png", false, getNotificationZone())
    guiSetProperty(Notification[IDentify], "ImageColours", "tl:FE"..string.format("%.2x%.2x%.2x", red, green, blue).." tr:FE"..string.format("%.2x%.2x%.2x", red, green, blue).." bl:FE"..string.format("%.2x%.2x%.2x", red, green, blue).." br:FE"..string.format("%.2x%.2x%.2x", red, green, blue).."")
    guiSetAlpha(Notification[IDentify], 0)
    
    setTimer(function()
    
        guiSetAlpha(Notification[IDentify], guiGetAlpha(Notification[IDentify])+0.1)
        
    end, 50, 10)
    table.insert(allNotifications, IDentify)
    
    
    textNotification[IDentify] = guiCreateLabel(icon ~= nil and 55 or 5, 15, icon ~= nil and w-10 or w-60, 35, text, false, Notification[IDentify])
    guiLabelSetVerticalAlign(textNotification[IDentify], "top")
    guiSetFont(textNotification[IDentify], guiCreateFont("fonts/light.ttf", 9))
    
    
    titleNotification[IDentify] = guiCreateLabel(icon ~= nil and 55 or 5, 0, icon ~= nil and w-10 or w-60, 15, title, false, Notification[IDentify])
    guiLabelSetVerticalAlign(titleNotification[IDentify], "top")
    guiSetFont(titleNotification[IDentify], guiCreateFont("fonts/medium.ttf", 11))
    if icon then iconNotificate[IDentify] = guiCreateStaticImage(0, 0, 50, 50, icon, false, Notification[IDentify]) end
    
    
    closeNotifi[IDentify] = guiCreateStaticImage(0, 0, w, height, "images/element.png", false, Notification[IDentify])
    guiSetAlpha(closeNotifi[IDentify], 0)
    guiBringToFront(closeNotifi[IDentify])
    
    destroy(IDentify, movable, title)
    triggerEvent("setSize", localPlayer, height)
    
    guiSetVisible(getNotificationClear(), true)
    
    return IDentify
end

function getNotificationElementWhereCanAddElement(id)
    if not isElement(closeNotifi[id]) then return false end
    return closeNotifi[id]
end

local newPositions, scrollCursor = 0, 0
local clicked = {}
function destroy(id, movable, title)
    addEventHandler("onClientGUIClick", getNotificationPane(), function() return 1 end, false)
    addEventHandler("onClientMouseEnter", closeNotifi[id], function() guiSetAlpha(closeNotifi[id], 0.3) end, false)
    addEventHandler("onClientMouseLeave", closeNotifi[id], function() guiSetAlpha(closeNotifi[id], 0) end, false)
    addEventHandler("onClientGUIClick", closeNotifi[id], function() triggerEvent("onClientSelectNotification", localPlayer, id, title) closeTopbar() if movable then destroyNotification(id) end end, false)
    clicked[id] = false
    
    addEventHandler("onClientGUIMouseDown", closeNotifi[id], function(Button, ScrollX, ScrollY)
            
        if source ~= closeNotifi[id] then return 1 end
        if Button ~= "left" then return 1 end
            
        clicked[id] = true
        
        local scrollPositionX = guiGetPosition(Notification[id], false)
        newPositions = ScrollX-scrollPositionX
        scrollCursor = ScrollX
    end)
            
    addEventHandler("onClientGUIMouseUp", root, function()
            
        if source ~= closeNotifi[id] then return 1 end
        if not clicked[id] then return 1 end     
        
        local getPosX = guiGetPosition(Notification[id], false)
        if getPosX < 180 then moveBackNotification(id)
        else 
            if not movable then moveBackNotification(id)
            else destroyNotification(id) end
        end
        
        clicked[id] = false
    end)
    
    addEventHandler("onClientCursorMove", root, function(_, _, cursorPosX, cursorPosY)
        
        if not clicked[id] then return 1; end
        
        local phoneX, phoneY = getPhonePosition()
        local phonew, phoneh = getPhoneSize()
        local screenX, screenY = getScreenPosition()
        local notX, notY = guiGetPosition(Notification[id], false)
        local notW, notH = guiGetSize(Notification[id], false)
            
        local findPosition = cursorPosX-newPositions
        
        if findPosition < 0 then
            findPosition = 0 
            setCursorPosition(scrollCursor, cursorPosY)
        end 
        
        if cursorPosX > (phoneX+screenX+notW)-15 then
            findPosition = (phoneX+screenX+notW)-15
            setCursorPosition((phoneX+screenX+notW)-15, cursorPosY)
        end
        
        if notX < phonew-110 then guiSetAlpha(Notification[id], 1) end
        if notX >= phonew-110 and notX < phonew-100 then guiSetAlpha(Notification[id], 0.9) end
        if notX >= phonew-100 and notX < phonew-90 then guiSetAlpha(Notification[id], 0.8) end
        if notX >= phonew-90 and notX < phonew-80 then guiSetAlpha(Notification[id], 0.7) end
        if notX >= phonew-80 and notX < phonew-70 then guiSetAlpha(Notification[id], 0.6) end
        if notX >= phonew-70 and notX < phonew-60 then guiSetAlpha(Notification[id], 0.5) end
        if notX >= phonew-60 and notX < phonew-50 then guiSetAlpha(Notification[id], 0.4) end
        if notX >= phonew-50 and notX < phonew-40 then guiSetAlpha(Notification[id], 0.3) end
        if notX >= phonew-40 and notX < phonew-30 then guiSetAlpha(Notification[id], 0.2) end
        if notX >= phonew-30 and notX < phonew-20 then guiSetAlpha(Notification[id], 0.1) end
        if notX >= phonew-20 then guiSetAlpha(Notification[id], 0) end
        
        if cursorPosY < phoneY+screenY+notY+40 then setCursorPosition(cursorPosX, phoneY+screenY+notY+40) end
        if cursorPosY > (phoneY+screenY+notY+40+notH)-15 then setCursorPosition(cursorPosX, (phoneY+screenY+notY+40+notH)-15) end
        --if cursorPosY < (phoneY+screenY+notY+notH)-10 then setCursorPosition(cursorPosX, (phoneY+screenY+notY+notH)-10) end
        --if cursorPosY > (phoneY+screenY+notY+notH+notH)-20 then setCursorPosition(cursorPosX, (phoneY+screenY+notY+notH+notH)-20) end
        
        guiSetPosition(Notification[id], findPosition, notY, false)
    end)
end

local enableNotification={}
local getModuleNotification={}
local elementPosY={}
function moveBackNotification(id)
    if not isElement(Notification[id]) then return false end
    if enableNotification[id] then return false end
    local posX = 0
    posX, elementPosY[id] = guiGetPosition(Notification[id], false)
    
    getModuleNotification[id] = math.fmod(posX, 10)
    enableNotification[id] = true
end

addEventHandler("onClientRender", root, function()
    for i = 0, table.maxn(enableNotification) do if enableNotification[i] == true then 
        local newPosX = guiGetPosition(Notification[i], false)
        if newPosX <= 0 then
            guiSetPosition(Notification[i], 0, elementPosY[i], false)
            enableNotification[i] = false
            cancelEvent() 
            return 1 
        else
            if num == 0 then
                num = 1
                guiSetPosition(Notification[i], newPosX-getModuleNotification[i], elementPosY[i], false)
            else
                guiSetPosition(Notification[i], newPosX-10, elementPosY[i], false)
            end
        
            if newPosX < phoneWid-110 then guiSetAlpha(Notification[i], 1) end
            if newPosX >= phoneWid-110 and newPosX < phoneWid-100 then guiSetAlpha(Notification[i], 0.9) end
            if newPosX >= phoneWid-100 and newPosX < phoneWid-90 then guiSetAlpha(Notification[i], 0.8) end
            if newPosX >= phoneWid-90 and newPosX < phoneWid-80 then guiSetAlpha(Notification[i], 0.7) end
            if newPosX >= phoneWid-80 and newPosX < phoneWid-70 then guiSetAlpha(Notification[i], 0.6) end
            if newPosX >= phoneWid-70 and newPosX < phoneWid-60 then guiSetAlpha(Notification[i], 0.5) end
            if newPosX >= phoneWid-60 and newPosX < phoneWid-50 then guiSetAlpha(Notification[i], 0.4) end
            if newPosX >= phoneWid-50 and newPosX < phoneWid-40 then guiSetAlpha(Notification[i], 0.3) end
            if newPosX >= phoneWid-40 and newPosX < phoneWid-30 then guiSetAlpha(Notification[i], 0.2) end
            if newPosX >= phoneWid-30 and newPosX < phoneWid-20 then guiSetAlpha(Notification[i], 0.1) end
            if newPosX >= phoneWid-20 then guiSetAlpha(Notification[i], 0) end
        end
    end end
end)

local notificationEditor={}
local elementsPos={}
local elementsWidth={}
local elementsHeight={}
function destroyNotification(id)
    if not isElement(Notification[id]) then return false end
    if notificationEditor[id] then return false end
    
    _, elementsPos[id] = guiGetPosition(Notification[id], false)
    elementsWidth[id], elementsHeight[id] = guiGetSize(Notification[id], false)

    notificationEditor[id] = true
end

addEventHandler("onClientRender", root, function()
    for i = 0, table.maxn(notificationEditor) do if notificationEditor[i] == true then 
        if not isElement(Notification[i]) then
            notificationEditor[i] = false
            cancelEvent() 
            return 1 
        end
        
        local newPosX = guiGetPosition(Notification[i], false)
        if newPosX == false then
            notificationEditor[i] = false
            cancelEvent() 
            return 1 
        end
        
        if newPosX < phoneWid-110 then guiSetAlpha(Notification[i], 1) end
        if newPosX >= phoneWid-110 and newPosX < phoneWid-100 then guiSetAlpha(Notification[i], 0.9) end
        if newPosX >= phoneWid-100 and newPosX < phoneWid-90 then guiSetAlpha(Notification[i], 0.8) end
        if newPosX >= phoneWid-90 and newPosX < phoneWid-80 then guiSetAlpha(Notification[i], 0.7) end
        if newPosX >= phoneWid-80 and newPosX < phoneWid-70 then guiSetAlpha(Notification[i], 0.6) end
        if newPosX >= phoneWid-70 and newPosX < phoneWid-60 then guiSetAlpha(Notification[i], 0.5) end
        if newPosX >= phoneWid-60 and newPosX < phoneWid-50 then guiSetAlpha(Notification[i], 0.4) end
        if newPosX >= phoneWid-50 and newPosX < phoneWid-40 then guiSetAlpha(Notification[i], 0.3) end
        if newPosX >= phoneWid-40 and newPosX < phoneWid-30 then guiSetAlpha(Notification[i], 0.2) end
        if newPosX >= phoneWid-30 and newPosX < phoneWid-20 then guiSetAlpha(Notification[i], 0.1) end
        if newPosX >= phoneWid-20 then guiSetAlpha(Notification[i], 0) end
        
        if newPosX > elementsWidth[i] then
            destroyElement(Notification[i])
            table.remove(allNotifications, i) 
            triggerEvent("setSize", localPlayer, -elementsHeight[i])
            
            for z = 0, table.maxn(allNotifications)+1 do 
                if isElement(Notification[z]) then
                    local nPosX, nPosY = guiGetPosition(Notification[z], false)
                    if nPosY > elementsPos[i] then guiSetPosition(Notification[z], nPosX, nPosY-elementsHeight[i]-1, false) end
                end
            end
            local notHeight = getNotificationMenuSize()
            if notHeight <= 0 then closeTopbar() guiSetVisible(getNotificationClear(), false) end
            return 1
        end
        guiSetPosition(Notification[i], newPosX+10, elementsPos[i], false)
    end end
end)
--[[function destroyNotification(id)
    if not isElement(Notification[id]) then return false end
    
    local posX, posY = guiGetPosition(Notification[id], false)
    local width, heights = guiGetSize(Notification[id], false)
    
    nottimer[id] = setTimer(function()
        if not isElement(Notification[id]) then 
            if isTimer(nottimer[id]) then 
                return 1; 
            end 
        end
        
        local timerPosX = guiGetPosition(Notification[id], false)
        if timerPosX == false then 
            return 1; 
        end
        
        if timerPosX <= width then
            guiSetPosition(Notification[id], timerPosX+18, posY, false)
        else
            if not isElement(Notification[id]) then 
                return 1; 
            end
            
            destroyElement(Notification[id])
            table.remove(allNotifications, id) 
            triggerEvent("setSize", localPlayer, -heights)
            
            for i = 0, table.maxn(allNotifications)+1 do 
            
                if isElement(Notification[i]) then
        
                    local nPosX, nPosY = guiGetPosition(Notification[i], false)
                    if nPosY > posY then guiSetPosition(Notification[i], nPosX, nPosY-heights-1, false) end
                    
                end
            end
            local notHeight = getNotificationMenuSize()
            if notHeight <= 0 then closeTopbar() guiSetVisible(getNotificationClear(), false) end
        end
        if not isElement(Notification[id]) then 
            return 1; 
        end
        
        if timerPosX < phonew-110 then guiSetAlpha(Notification[id], 1) end
        if timerPosX >= phonew-110 and timerPosX < phonew-100 then guiSetAlpha(Notification[id], 0.9) end
        if timerPosX >= phonew-100 and timerPosX < phonew-90 then guiSetAlpha(Notification[id], 0.8) end
        if timerPosX >= phonew-90 and timerPosX < phonew-80 then guiSetAlpha(Notification[id], 0.7) end
        if timerPosX >= phonew-80 and timerPosX < phonew-70 then guiSetAlpha(Notification[id], 0.6) end
        if timerPosX >= phonew-70 and timerPosX < phonew-60 then guiSetAlpha(Notification[id], 0.5) end
        if timerPosX >= phonew-60 and timerPosX < phonew-50 then guiSetAlpha(Notification[id], 0.4) end
        if timerPosX >= phonew-50 and timerPosX < phonew-40 then guiSetAlpha(Notification[id], 0.3) end
        if timerPosX >= phonew-40 and timerPosX < phonew-30 then guiSetAlpha(Notification[id], 0.2) end
        if timerPosX >= phonew-30 and timerPosX < phonew-20 then guiSetAlpha(Notification[id], 0.1) end
        if timerPosX >= phonew-20 then guiSetAlpha(Notification[id], 0) end
    end, 50, 23)
end]]

function getNotificationCount()
    return table.maxn(allNotifications)
end

function getNotificationTable()
    return allNotifications
end

function createPhoneInfo(text)
    local w, h = getPhoneSize()
    local x = getScreenPosition()
    
    local staticInfo = guiCreateStaticImage(x, h-20-(20*(select(2, text:gsub('\n', '\n'))+1)), w, 20*(select(2, text:gsub('\n', '\n'))+1), "images/element.png", false, getPhone())
    guiSetProperty(staticInfo, "ImageColours", "tl:99444444 tr:99444444 bl:99444444 br:99444444")
    
    local labelInfo = guiCreateLabel(0, 0, w, 20*(select(2, text:gsub('\n', '\n'))+1), tostring(text), false, staticInfo)
    guiLabelSetHorizontalAlign(labelInfo, "center")
    guiLabelSetVerticalAlign(labelInfo, "center")
    guiSetFont(labelInfo, guiCreateFont("fonts/regular.ttf", 11))
    
    guiSetAlpha(staticInfo, 0)
    
    local count = 0
    setTimer(function()
        count = count+1
        
        guiBringToFront(staticInfo)
        
        if count <= 10 then 
            guiSetAlpha(staticInfo, guiGetAlpha(staticInfo)+0.1)
            
        elseif count >= 90 and count <= 100 then 
            guiSetAlpha(staticInfo, guiGetAlpha(staticInfo)-0.1)
            
        elseif count > 100 then 
            destroyElement(staticInfo) 
        end
        
    end, 50, 101)
end
local IDentifyPane = 0

local disableScreen={}
local acceptPanel={}
local textPanel={}
local editPanel={}
local button1={}
local but1txt={}
local button2={}
local but2txt={}
local button3={}
local but3txt={}
local button4={}
local but4txt={}

local panelTimer={}

function setVisibleAcceptPanel(id, bool)
    if not isElement(disableScreen[id]) then return 1 end
    if isTimer(panelTimer[id]) then return 1 end 
    
    if bool ~= true and bool ~= false then bool = true end
    
    if bool == true then guiSetVisible(disableScreen[id], true) end
    local CountAlpha = 0
    
    panelTimer[id] = setTimer(function()
        CountAlpha = CountAlpha+1
        if bool == true then guiSetAlpha(disableScreen[id], guiGetAlpha(disableScreen[id])+0.1)
        else guiSetAlpha(disableScreen[id], guiGetAlpha(disableScreen[id])-0.1) end
        if CountAlpha == 11 then guiSetVisible(disableScreen[id], bool) end
    end, 70, 11)
    
    guiBringToFront(disableScreen[id])
end

function createAcceptPanel(text, but1, but2, but3, but4)
    local w, h = getPhoneSize()
    --local x, y = getScreenPosition()
    if not but1 then but1 = "OK" end
    IDentifyPane = IDentifyPane+1 
    
    text = text:gsub("\n", "\n   ")
    local size = 20*(select(2, text:gsub('\n', '\n'))+1)+30
    text = "   "..text
    
    disableScreen[IDentifyPane] = guiCreateStaticImage(0, 0, w, h, "images/element.png", false, getDesktop())
    guiSetProperty(disableScreen[IDentifyPane], "ImageColours", "tl:AA444444 tr:AA444444 bl:AA444444 br:AA444444")
    guiBringToFront(disableScreen[IDentifyPane])
    
    acceptPanel[IDentifyPane] = guiCreateStaticImage(0, h-size-30, w, size+30, "images/element.png", false, disableScreen[IDentifyPane])
    guiSetProperty(acceptPanel[IDentifyPane], "ImageColours", "tl:00000000 tr:00000000 bl:FF000000 br:FF000000")
    
    textPanel[IDentifyPane] = guiCreateLabel(0, 0, w, size, tostring(text), false, acceptPanel[IDentifyPane])
    guiLabelSetVerticalAlign(textPanel[IDentifyPane], "center")
    guiSetFont(textPanel[IDentifyPane], guiCreateFont("fonts/regular.ttf", 10))
    
    local numer = w
    if but2 and not but3 and not but4 then numer = numer/2 end
    if but2 and but3 and not but4 then numer = numer/3 end
    if but2 and but3 and but4 then numer = numer/4 end
    
    button1[IDentifyPane] = guiCreateStaticImage(0, size, numer, 30, "images/element.png", false, acceptPanel[IDentifyPane])
    guiSetProperty(button1[IDentifyPane], "ImageColours", "tl:22222222 tr:22222222 bl:22222222 br:22222222")
    
    but1txt[IDentifyPane] = guiCreateLabel(0, 0, numer, 30, tostring(but1), false, button1[IDentifyPane])
    guiLabelSetVerticalAlign(but1txt[IDentifyPane], "center")
    guiLabelSetHorizontalAlign(but1txt[IDentifyPane], "center")
    guiSetFont(but1txt[IDentifyPane], guiCreateFont("fonts/bold.ttf", 10))
    
    button(IDentifyPane)
    
    if but2 then
        button2[IDentifyPane] = guiCreateStaticImage(numer, size, numer, 30, "images/element.png", false, acceptPanel[IDentifyPane])
        guiSetProperty(button2[IDentifyPane], "ImageColours", "tl:22222222 tr:22222222 bl:22222222 br:22222222")
        
        but2txt[IDentifyPane] = guiCreateLabel(0, 0, numer, 30, tostring(but2), false, button2[IDentifyPane])
        guiLabelSetVerticalAlign(but2txt[IDentifyPane], "center")
        guiLabelSetHorizontalAlign(but2txt[IDentifyPane], "center")
        guiSetFont(but2txt[IDentifyPane], guiCreateFont("fonts/bold.ttf", 10))
        
        buttonz(IDentifyPane, 2)
    end
    
    if but3 then
        button3[IDentifyPane] = guiCreateStaticImage(numer+numer, size, numer, 30, "images/element.png", false, acceptPanel[IDentifyPane])
        guiSetProperty(button3[IDentifyPane], "ImageColours", "tl:22222222 tr:22222222 bl:22222222 br:22222222")
        
        but3txt[IDentifyPane] = guiCreateLabel(0, 0, numer, 30, tostring(but3), false, button3[IDentifyPane])
        guiLabelSetVerticalAlign(but3txt[IDentifyPane], "center")
        guiLabelSetHorizontalAlign(but3txt[IDentifyPane], "center")
        guiSetFont(but3txt[IDentifyPane], guiCreateFont("fonts/bold.ttf", 10))
    
        buttonz(IDentifyPane, 3)
    end
    
    if but4 then
        button4[IDentifyPane] = guiCreateStaticImage(numer+numer+numer, size, numer, 30, "images/element.png", false, acceptPanel[IDentifyPane])
        guiSetProperty(button4[IDentifyPane], "ImageColours", "tl:22222222 tr:22222222 bl:22222222 br:22222222")
        
        but4txt[IDentifyPane] = guiCreateLabel(0, 0, numer, 30, tostring(but4), false, button4[IDentifyPane])
        guiLabelSetVerticalAlign(but4txt[IDentifyPane], "center")
        guiLabelSetHorizontalAlign(but4txt[IDentifyPane], "center")
        guiSetFont(but4txt[IDentifyPane], guiCreateFont("fonts/bold.ttf", 10))
    
        buttonz(IDentifyPane, 4)
    end
    
    guiSetAlpha(disableScreen[IDentifyPane], 0)
    
    setTimer(function()
        guiSetAlpha(disableScreen[IDentifyPane], guiGetAlpha(disableScreen[IDentifyPane])+0.1)
    end, 70, 10)
    
    return acceptPanel[IDentifyPane], IDentifyPane
end

function createEditAcceptPanel(text, but1, but2, but3, but4, pass)
    local w, h = getPhoneSize()
    --local x, y = getScreenPosition()
    if not but1 then but1 = "OK" end
    if not pass or (pass ~= true and pass ~= false) then pass = false end
    IDentifyPane = IDentifyPane+1 
    
    text = text.."\n\n\n"
    text = text:gsub("\n", "\n   ")
    local size = 20*(select(2, text:gsub('\n', '\n'))+1)+30
    text = "   "..text
    
    disableScreen[IDentifyPane] = guiCreateStaticImage(0, 0, w, h, "images/element.png", false, getDesktop())
    guiSetProperty(disableScreen[IDentifyPane], "ImageColours", "tl:AA444444 tr:AA444444 bl:AA444444 br:AA444444")
    guiBringToFront(disableScreen[IDentifyPane])
    
    acceptPanel[IDentifyPane] = guiCreateStaticImage(0, h-size-30, w, size+30, "images/element.png", false, disableScreen[IDentifyPane])
    guiSetProperty(acceptPanel[IDentifyPane], "ImageColours", "tl:00000000 tr:00000000 bl:FF000000 br:FF000000")
    
    textPanel[IDentifyPane] = guiCreateLabel(0, 0, w, size, tostring(text), false, acceptPanel[IDentifyPane])
    guiLabelSetVerticalAlign(textPanel[IDentifyPane], "center")
    guiSetFont(textPanel[IDentifyPane], guiCreateFont("fonts/regular.ttf", 10))
    
    editPanel[IDentifyPane] = guiCreateEdit(20, size-50, w-40, 25, "", false, textPanel[IDentifyPane])
    guiSetAlpha(editPanel[IDentifyPane], 0.5)
    if pass then guiEditSetMasked(editPanel[IDentifyPane], true) end
    
    edit(IDentifyPane)
    
    local numer = w
    if but2 and not but3 and not but4 then numer = numer/2 end
    if but2 and but3 and not but4 then numer = numer/3 end
    if but2 and but3 and but4 then numer = numer/4 end
    
    button1[IDentifyPane] = guiCreateStaticImage(0, size, numer, 30, "images/element.png", false, acceptPanel[IDentifyPane])
    guiSetProperty(button1[IDentifyPane], "ImageColours", "tl:22222222 tr:22222222 bl:22222222 br:22222222")
    
    but1txt[IDentifyPane] = guiCreateLabel(0, 0, numer, 30, tostring(but1), false, button1[IDentifyPane])
    guiLabelSetVerticalAlign(but1txt[IDentifyPane], "center")
    guiLabelSetHorizontalAlign(but1txt[IDentifyPane], "center")
    guiSetFont(but1txt[IDentifyPane], guiCreateFont("fonts/bold.ttf", 10))
    
    button(IDentifyPane, true)
    
    if but2 then
        button2[IDentifyPane] = guiCreateStaticImage(numer, size, numer, 30, "images/element.png", false, acceptPanel[IDentifyPane])
        guiSetProperty(button2[IDentifyPane], "ImageColours", "tl:22222222 tr:22222222 bl:22222222 br:22222222")
        
        but2txt[IDentifyPane] = guiCreateLabel(0, 0, numer, 30, tostring(but2), false, button2[IDentifyPane])
        guiLabelSetVerticalAlign(but2txt[IDentifyPane], "center")
        guiLabelSetHorizontalAlign(but2txt[IDentifyPane], "center")
        guiSetFont(but2txt[IDentifyPane], guiCreateFont("fonts/bold.ttf", 10))
        
        buttonz(IDentifyPane, 2, true)
    end
    
    if but3 then
        button3[IDentifyPane] = guiCreateStaticImage(numer+numer, size, numer, 30, "images/element.png", false, acceptPanel[IDentifyPane])
        guiSetProperty(button3[IDentifyPane], "ImageColours", "tl:22222222 tr:22222222 bl:22222222 br:22222222")
        
        but3txt[IDentifyPane] = guiCreateLabel(0, 0, numer, 30, tostring(but3), false, button3[IDentifyPane])
        guiLabelSetVerticalAlign(but3txt[IDentifyPane], "center")
        guiLabelSetHorizontalAlign(but3txt[IDentifyPane], "center")
        guiSetFont(but3txt[IDentifyPane], guiCreateFont("fonts/bold.ttf", 10))
    
        buttonz(IDentifyPane, 3, true)
    end
    
    if but4 then
        button4[IDentifyPane] = guiCreateStaticImage(numer+numer+numer, size, numer, 30, "images/element.png", false, acceptPanel[IDentifyPane])
        guiSetProperty(button4[IDentifyPane], "ImageColours", "tl:22222222 tr:22222222 bl:22222222 br:22222222")
        
        but4txt[IDentifyPane] = guiCreateLabel(0, 0, numer, 30, tostring(but4), false, button4[IDentifyPane])
        guiLabelSetVerticalAlign(but4txt[IDentifyPane], "center")
        guiLabelSetHorizontalAlign(but4txt[IDentifyPane], "center")
        guiSetFont(but4txt[IDentifyPane], guiCreateFont("fonts/bold.ttf", 10))
    
        buttonz(IDentifyPane, 4, true)
    end
    
    guiSetAlpha(disableScreen[IDentifyPane], 0)
    
    setTimer(function()
        guiSetAlpha(disableScreen[IDentifyPane], guiGetAlpha(disableScreen[IDentifyPane])+0.1)
    end, 70, 10)
    
    return acceptPanel[IDentifyPane], IDentifyPane
end

function getAcceptPanel(id)
    if not isElement(disableScreen[id]) then return 1 end
    return acceptPanel[id] 
end

function edit(id)
    addEventHandler("onClientGUIAccepted", editPanel[id], function()
        if source ~= editPanel[id] then return false end
        setVisibleAcceptPanel(id, false) 
        triggerEvent("onClientClickFirstAccept", localPlayer, id, bool == true and guiGetText(editPanel[id]) or false)
    end)
end

function button(id, bool)
    addEventHandler("onClientGUIClick", textPanel[id], function()
        setVisibleAcceptPanel(id, true)
    end, false)
    
    addEventHandler("onClientGUIClick", disableScreen[id], function()
        setVisibleAcceptPanel(id, false)
    end, false)
    
    addEventHandler("onClientGUIClick", but1txt[id], function()
        setVisibleAcceptPanel(id, false) 
        triggerEvent("onClientClickFirstAccept", localPlayer, id, bool == true and guiGetText(editPanel[id]) or false)
    end, false)
    
    addEventHandler("onClientMouseEnter", but1txt[id], function() if source == but1txt[id] then guiSetAlpha(but1txt[id], 0.5) end end)
    addEventHandler("onClientMouseLeave", but1txt[id], function() if source == but1txt[id] then guiSetAlpha(but1txt[id], 1  ) end end)
end

function buttonz(id, num, bool)
    local ele, str = but2txt, "onClientClickSecondAccept"
    if num == 2 then ele = but2txt str = "onClientClickSecondAccept" end
    if num == 3 then ele = but3txt str = "onClientClickThirdAccept" end
    if num == 4 then ele = but4txt str = "onClientClickFourAccept" end
    addEventHandler("onClientGUIClick", ele[id], function()
        setVisibleAcceptPanel(id, false) 
        triggerEvent(str, localPlayer, id, bool == true and guiGetText(editPanel[id]) or false)
    end, false)
    addEventHandler("onClientMouseEnter", ele[id], function() if source == ele[id] then guiSetAlpha(ele[id], 0.5) end end)
    addEventHandler("onClientMouseLeave", ele[id], function() if source == ele[id] then guiSetAlpha(ele[id], 1  ) end end)
end
--[[Triggers from this file:
1) onClientClickFirstAccept; onClientClickSecondAccept; onClientClickThirdAccept; onClientClickFourAccept
Returns ID of accepted button in accept-panel

2) onClientDisableSwitcher; onClientEnableSwitcher
Returns ID of switcher, what changed
]]

local settingsInfo = {}
local clicked = {}
local setNewPosition = {}

local settsOpener = {}
local settsCloser = {}
local settsX = {}
local settsY = {}
function openSettingsElement(id)
    if not isElement(settingsPanel[id]) then return false end
    if settsCloser[id] then return false end
    
    settsX[id], settsY[id] = guiGetPosition(settingsPanel[id], false)
    settsOpener[id] = true
end

addEventHandler("onClientRender", root, function()
    for i = 1, table.maxn(settsOpener) do  
        if settsOpener[i] == true then 
            local x, y = guiGetPosition(settingsPanel[i], false)
        
            if y < phoneHei-190 then 
                guiSetPosition(settingsPanel[i], x, phoneHei-205, false)
                settsOpener[i] = false
                cancelEvent()
                return 1 
            end
            guiSetPosition(settingsPanel[i], x, y-15, false)
            
            if y == phoneHei-15  then guiSetAlpha(settingsPanel[i], 0)
            elseif y < phoneHei-15 then guiSetAlpha(settingsPanel[i], 1) end
        end 
    end
end)
function closeSettingsElement(id)
    if not isElement(settingsPanel[id]) then return false end
    if settsOpener[id] then return false end
    
    settsX[id], settsY[id] = guiGetPosition(settingsPanel[id], false)
    settsCloser[id] = true
end

addEventHandler("onClientRender", root, function()
    for i = 1, table.maxn(settsCloser) do  
        if settsCloser[i] == true then 
            local x, y = guiGetPosition(settingsPanel[i], false)
        
            if y >= phoneHei-15 then 
                guiSetPosition(settingsPanel[i], x, phoneHei-15, false)
                guiSetAlpha(settingsPanel[i], 0)
                settsCloser[i] = false
                cancelEvent()
                return 1 
            end
            
            guiSetPosition(settingsPanel[i], x, y+15, false)
        end 
    end
end)

local allElementsOfSettsPanel={}
local allDetailsOfSettsPanel={}
function createSettingsPanel(id)
    if not isElement(phoneWindow[id]) then return false end
    if isElement(settingsPanel[id]) then return false end
    
    settingsInfo[id] = {}
    allElementsOfSettsPanel[id]={}
    allDetailsOfSettsPanel[id]={}
    
    settingsPanel[id] = guiCreateStaticImage(0, phoneHei-15, phoneWid, 205, "images/element.png", false, phoneWindow[id])
    guiSetProperty(settingsPanel[id], "ImageColours", "tl:CC222222 tr:CC222222 bl:CC222222 br:CC222222")
    
    settingsInfo[id]["Scroller"] = guiCreateStaticImage(phoneWid/2-25, 0, 50, 13, "images/scroll.png", false, settingsPanel[id])
    guiSetProperty(settingsInfo[id]["Scroller"], "ImageColours", "tl:88999999 tr:88999999 bl:88999999 br:88999999")
    guiSetEnabled(settingsInfo[id]["Scroller"], false)
        
    settingsInfo[id]["Paned"]  = guiCreateScrollPane(0, 15, phoneWid, 190, false, settingsPanel[id])
    
    local allEls = 0
    settingsInfo[id]["Pane"] = guiCreateStaticImage(0, 0, phoneWid, 0, "images/element.png", false, settingsInfo[id]["Paned"])
    guiSetProperty(settingsInfo[id]["Pane"], "ImageColours", "tl:00000000 tr:00000000 bl:00000000 br:00000000")
    
    clicked[id] = false
    setNewPosition[id] = 0
    settsOpener[id] = false
    settsCloser[id] = false
    
    addEventHandler("onClientGUIMouseDown", root, function(Button, _, ScrollY)
        if source ~= settingsPanel[id] then return 1 end
        if Button ~= "left" then return 1 end
            
        guiBringToFront(settingsPanel[id])
            
        clicked[id] = true
            
        local _, ScrollPosition = guiGetPosition(settingsPanel[id], false)
        setNewPosition[id] = ScrollY-ScrollPosition
    end)
        
    addEventHandler("onClientGUIMouseUp", root, function()
        if source ~= settingsPanel[id] then return 1 end
            
        guiBringToFront(settingsPanel[id])
            
        local _, ScrollPosition = guiGetPosition(settingsPanel[id], false)
        local phonew, phoneh = getPhoneSize() 
            
        if clicked[id] then
            if ScrollPosition < phoneh-102 then openSettingsElement(id) 
            else closeSettingsElement(id) end
        else
            if ScrollPosition < phoneh-102 then closeSettingsElement(id)
            else openSettingsElement(id) end
        end
            
        clicked[id] = false
    end)
        
    addEventHandler("onClientCursorMove", root, function(_, _, cursorPosX, cursorPosY)
        
        if not clicked[id] then return 1; end
            
        local phoneX, phoneY = getPhonePosition()
        local phonew, phoneh = getPhoneSize() 
        local _, newYPos     = guiGetPosition(settingsPanel[id], false)
            
        local findPosition = cursorPosY-setNewPosition[id]
            
        if findPosition < phoneh-205 then 
            findPosition = phoneh-205 
            setCursorPosition(cursorPosX, findPosition+5+phoneY+38)
        end 
        if findPosition > phoneh-15 then 
            findPosition = phoneh-15 
            setCursorPosition(cursorPosX, findPosition+5+phoneY+38)
        end 
            
        if cursorPosX < phoneX+15 then setCursorPosition(phoneX+17, findPosition+5+phoneY+38) end
        if cursorPosX > phoneX+10+phonew then setCursorPosition(phoneX+phonew, findPosition+5+phoneY+38) end
            
        if findPosition == phoneh-15  then guiSetAlpha(settingsPanel[id], 0)
        elseif findPosition < phoneh-15 then guiSetAlpha(settingsPanel[id], 1) end
                
        guiSetPosition(settingsPanel[id], 0, findPosition, false)
    end)
    guiSetAlpha(settingsPanel[id], 0)
    
    return id
end

function addSettingsPanelElement(id, text)
    if not isElement(settingsPanel[id]) then return false end
    local allEls = 0
    for i = 0, table.maxn(allElementsOfSettsPanel[id]) do if isElement(allElementsOfSettsPanel[id][i]) then allEls = allEls+1 outputDebugString("True") end end
    if not text then text = "Option "..tostring(allEls) end
    
    allDetailsOfSettsPanel[id][allEls] = guiCreateStaticImage(10, 26*allEls, phoneWid-20, 25, "images/element.png", false, settingsInfo[id]["Pane"])
    guiSetProperty(allDetailsOfSettsPanel[id][allEls], "ImageColours", "tl:CC222222 tr:CC222222 bl:CC222222 br:CC222222")
    
    allElementsOfSettsPanel[id][allEls] = guiCreateLabel(0, 0, phoneWid-20, 25, tostring(text), false, allDetailsOfSettsPanel[id][allEls])
    guiLabelSetHorizontalAlign(allElementsOfSettsPanel[id][allEls], "center")
    guiLabelSetVerticalAlign(allElementsOfSettsPanel[id][allEls], "center")
    guiSetFont(allElementsOfSettsPanel[id][allEls], guiCreateFont("fonts/medium.ttf", 12))
    
    guiSetSize(settingsInfo[id]["Pane"], phoneWid, (26*allEls)+26, false)
    
    addEventHandler("onClientMouseEnter", allElementsOfSettsPanel[id][allEls], function() 
        if source == allElementsOfSettsPanel[id][allEls] then 
            guiSetProperty(allDetailsOfSettsPanel[id][allEls], "ImageColours", "tl:CC555555 tr:CC555555 bl:CC555555 br:CC555555")
            guiSetAlpha(allElementsOfSettsPanel[id][allEls], 0.5) 
        end 
    end)
    addEventHandler("onClientMouseLeave", allElementsOfSettsPanel[id][allEls], function() 
        if source == allElementsOfSettsPanel[id][allEls] then 
            guiSetProperty(allDetailsOfSettsPanel[id][allEls], "ImageColours", "tl:CC222222 tr:CC222222 bl:CC222222 br:CC222222")
            guiSetAlpha(allElementsOfSettsPanel[id][allEls],  1 ) 
        end 
    end)
    addEventHandler("onClientGUIClick", allElementsOfSettsPanel[id][allEls], 
        function()
            if source == allElementsOfSettsPanel[id][allEls] then
                closeSettingsElement(id)
                triggerEvent("onClientSelectedSettingsPanelElement", localPlayer, id, tostring(text))
            end
        end, false)
    
end
