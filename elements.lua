local windowCount = 0
local phoneWindow={}
local phoneWindowStatusbarType={}
local phoneWindowStatusbarBy={}
function createPhoneWindow(colortop, colbottom, enablestatusbar, statusbartype)
    if enablestatusbar == nil or (enablestatusbar ~= true and enablestatusbar ~= false) then enablestatusbar = true end
    if statusbartype == nil or (statusbartype ~= "desktop" and statusbartype ~= "app") then statusbartype = "app" end
    
    if not colortop or type(colortop) == "userdata" then colortop = tocolor(80, 80, 80, 255) end 
    if not colbottom or type(colbottom) == "userdata" then colbottom = tocolor(30, 30, 30, 255) end 
    
    local w, h = getPhoneSize()
    windowCount = windowCount+1
    phoneWindow[windowCount] = guiCreateStaticImage(0, enablestatusbar == false and 0 or 20, w, enablestatusbar == false and h or h-20, "images/element.png", false, getDesktop())
    phoneWindowStatusbarType[windowCount] = statusbartype
    phoneWindowStatusbarBy[windowCount] = enablestatusbar
    
    colortop = string.format("%x", colortop)
    colbottom = string.format("%x", colbottom)
    guiSetProperty(phoneWindow[windowCount], "ImageColours", "tl:"..colortop.." tr:"..colortop.." bl:"..colbottom.." br:"..colbottom.."")
    
    guiSetVisible(getStatusbar(), enablestatusbar)
    --desktopNotbarType(statusbartype)
    
    guiBringToFront(getStatusbar())
    guiBringToFront(getNotbar())
    guiBringToFront(getNotbarMover())
    
    guiSetVisible(phoneWindow[windowCount], false)
    
    return phoneWindow[windowCount], windowCount
end

function hideAllWindows()
    for i = 1, windowCount+1 do
        if not isElement(phoneWindow[i]) then return false end
        doAnimated(phoneWindow[i], false)
        desktopNotbarType("desktop")
        guiSetVisible(getStatusbar(), true)
    end
end

function showWindow(id)
    if not isElement(phoneWindow[id]) then return false end
    doAnimated(phoneWindow[id], true)
    desktopNotbarType(phoneWindowStatusbarType[id])
    guiSetVisible(getStatusbar(), phoneWindowStatusbarBy[id])
end

function hideWindow(id)
    if not isElement(phoneWindow[id]) then return false end
    doAnimated(phoneWindow[id], false)
    desktopNotbarType("desktop")
    guiSetVisible(getStatusbar(), true)
end

local elementTimer={}
local elementType={}
function doAnimated(element, booltype)
    if not isElement(element) then return 1 end
    if isTimer(elementTimer[element]) then return 1 end
    if booltype == nil or (booltype ~= false and booltype ~= true) then booltype = not elementType[element] end
    
    local counting = 0
    
    if booltype == true then 
        if elementType[element] == true then return 1 end
        elementType[element] = true
        local px, py = guiGetPosition(element, false)
        local wi, he = guiGetSize(element, false)
        guiSetVisible(element, true) 
        guiSetPosition(element, px+(22*3), py+(22*8), false) 
        guiSetSize(element, wi-(22*6), he-(22*9), false) 
        guiSetAlpha(element, 0)
    
        elementTimer[element] = setTimer(function()
            counting = counting+1
            local posX, posY = guiGetPosition(element, false)
            local wid, hei = guiGetSize(element, false)
            guiSetPosition(element, posX-3, posY-8, false)
            guiSetSize(element, wid+6, hei+9, false)
            guiSetAlpha(element, guiGetAlpha(element)+0.05)
            if counting >= 22 then 
                guiSetPosition(element, px, py, false) 
                guiSetAlpha(element, 1)
                guiSetSize(element, wi, he, false) 
            end
            guiBringToFront(element)
        end, 50, 22)
    else
        if elementType[element] == false then return 1 end
        elementType[element] = false
        local px, py = guiGetPosition(element, false)
        local wi, he = guiGetSize(element, false)
        guiSetVisible(element, true) 
        guiSetPosition(element, px, py, false) 
        guiSetSize(element, wi, he, false) 
        guiSetAlpha(element, 1)
        
        elementTimer[element] = setTimer(function()
            counting = counting+1
            local posX, posY = guiGetPosition(element, false)
            local wid, hei = guiGetSize(element, false)
            guiSetPosition(element, posX+3, posY+8, false)
            guiSetSize(element, wid-6, hei-9, false)
            guiSetAlpha(element, guiGetAlpha(element)-0.05)
            if counting >= 22 then 
                guiSetVisible(element, false) 
                guiSetPosition(element, px, py, false) 
                guiSetAlpha(element, 1)
                guiSetSize(element, wi, he, false) 
            end
            guiBringToFront(element)
        end, 50, 22)
    end
end

local switchCount = 0
local phoneSwitcher={}
local enablingSwitch={}
local timer={}
function createSwitcher(x, y, enabled, parent)
    if not x or not tonumber(x) then x = 20 end
    if not y or not tonumber(y) then y = 20 end
    if enabled == nil or (enabled ~= false and enabled ~= true) then enabled = false end
    if parent == nil or not isElement(parent) then parent = getDesktop() end
    
    switchCount = switchCount+1
    phoneSwitcher[switchCount]={}
    phoneSwitcher[switchCount]["Switcher"] = guiCreateStaticImage(x, y, 50, 20, "images/switcher.png", false, parent)
    phoneSwitcher[switchCount]["Switch"] = guiCreateStaticImage(0, 0, 20, 20, "images/switch.png", false, phoneSwitcher[switchCount]["Switcher"])
    enablingSwitch[phoneSwitcher[switchCount]["Switcher"] ] = enabled
    if enabled == true then guiSetProperty(phoneSwitcher[switchCount]["Switcher"], "ImageColours", "tl:FF00FF00 tr:FF00FF00 bl:FF00FF00 br:FF00FF00") guiSetPosition(phoneSwitcher[switchCount]["Switch"], 30, 0, false)
    else guiSetProperty(phoneSwitcher[switchCount]["Switcher"], "ImageColours", "tl:FFFF0000 tr:FFFF0000 bl:FFFF0000 br:FFFF0000") guiSetPosition(phoneSwitcher[switchCount]["Switch"], 0, 0, false) end
     
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
                    guiSetPosition(phoneSwitcher[id]["Switch"], x-10, 0, false)
                    guiSetProperty(phoneSwitcher[id]["Switcher"], "ImageColours", "tl:FFFF0000 tr:FFFF0000 bl:FFFF0000 br:FFFF0000")
                    
                end, 50, 3)
                
                triggerEvent("onClientDisableSwitcher", localPlayer, id)
                
            elseif enablingSwitch[phoneSwitcher[id]["Switcher"] ] == false then
            
                if isTimer(timer[id]) then return 1 end
                enablingSwitch[phoneSwitcher[id]["Switcher"] ] = true
                
                timer[id] = setTimer(function()
                
                    local x = guiGetPosition(phoneSwitcher[id]["Switch"], false)
                    guiSetPosition(phoneSwitcher[id]["Switch"], x+10, 0, false)
                    guiSetProperty(phoneSwitcher[id]["Switcher"], "ImageColours", "tl:FF00FF00 tr:FF00FF00 bl:FF00FF00 br:FF00FF00")
                    
                end, 50, 3)
                
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
                    guiSetPosition(phoneSwitcher[id]["Switch"], x-10, 0, false)
                    guiSetProperty(phoneSwitcher[id]["Switcher"], "ImageColours", "tl:FFFF0000 tr:FFFF0000 bl:FFFF0000 br:FFFF0000")
                    
                end, 50, 3)
                
                triggerEvent("onClientDisableSwitcher", localPlayer, id)
                
            elseif enablingSwitch[phoneSwitcher[id]["Switcher"] ] == false then
            
                if isTimer(timer[id]) then return 1 end
                enablingSwitch[phoneSwitcher[id]["Switcher"] ] = true
                
                timer[id] = setTimer(function()
                
                    local x = guiGetPosition(phoneSwitcher[id]["Switch"], false)
                    guiSetPosition(phoneSwitcher[id]["Switch"], x+10, 0, false)
                    guiSetProperty(phoneSwitcher[id]["Switcher"], "ImageColours", "tl:FF00FF00 tr:FF00FF00 bl:FF00FF00 br:FF00FF00")
                    
                end, 50, 3)
                
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
        
        if cursorPosY < phoneY+screenY+notY+40 then setCursorPosition(cursorPosX, phoneY+screenY+notY+40) end
        if cursorPosY > (phoneY+screenY+notY+40+notH)-15 then setCursorPosition(cursorPosX, (phoneY+screenY+notY+40+notH)-15) end
        --if cursorPosY < (phoneY+screenY+notY+notH)-10 then setCursorPosition(cursorPosX, (phoneY+screenY+notY+notH)-10) end
        --if cursorPosY > (phoneY+screenY+notY+notH+notH)-20 then setCursorPosition(cursorPosX, (phoneY+screenY+notY+notH+notH)-20) end
        
        guiSetPosition(Notification[id], findPosition, notY, false)
    end)
end

local moveTimer={}
function moveBackNotification(id)
    if not isElement(Notification[id]) then return false end
    if isTimer(moveTimer[id]) then return false end
    local posX, posY = guiGetPosition(Notification[id], false)
    
    local getMod = math.fmod(posX, 40)
    local timerNumber =  math.abs( (posX-getMod) /40 )+1 
    
    local num = 0
    moveTimer[id] = setTimer(function()
        local newPosX = guiGetPosition(Notification[id], false)
        if newPosX == 0 then return 1 end
        if newPosX < 0 then newPosX = 0 end
        if newPosX > 0 then
            if num == 0 then
                num = 1
                guiSetPosition(Notification[id], newPosX-getMod, posY, false)
            else
                guiSetPosition(Notification[id], newPosX-40, posY, false)
            end
        end
    end, 50, timerNumber)
end

local nottimer={}
function destroyNotification(id)
    if not isElement(Notification[id]) then return false end
    if isTimer(nottimer[id]) then return 1; end 
    
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
            if isTimer(nottimer[id]) then 
                return 1; 
            end 
            return 1; 
        end
        
        if timerPosX <= width then
            guiSetPosition(Notification[id], timerPosX+18, posY, false)
        else
            if not isElement(Notification[id]) then 
                if isTimer(nottimer[id]) then 
                    return 1;  
                end 
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
    end, 50, 23)
end

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
local button1={}
local but1txt={}
local button2={}
local but2txt={}
local button3={}
local but3txt={}
local button4={}
local but4txt={}

function setVisibleAcceptPanel(id, bool)
    if not isElement(disableScreen[id]) then return 1 end
    
    if bool ~= true and bool ~= false then bool = true end
    
    if bool == true then guiSetVisible(disableScreen[id], true) end
    local CountAlpha = 0
    
    setTimer(function()
        CountAlpha = CountAlpha+1
        if bool == true then guiSetAlpha(disableScreen[IDentifyPane], guiGetAlpha(disableScreen[IDentifyPane])+0.1)
        else guiSetAlpha(disableScreen[IDentifyPane], guiGetAlpha(disableScreen[IDentifyPane])-0.1) end
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
    
    return IDentifyPane
end
function getAcceptPanel(id)
    if not isElement(disableScreen[id]) then return 1 end
    return acceptPanel[id] 
end

function button(id)
    addEventHandler("onClientGUIClick", textPanel[id], function()
        setVisibleAcceptPanel(id, true)
    end, false)
    
    addEventHandler("onClientGUIClick", disableScreen[id], function()
        setVisibleAcceptPanel(id, false)
    end, false)
    
    addEventHandler("onClientGUIClick", but1txt[id], function()
        setVisibleAcceptPanel(id, false) 
        triggerEvent("onClientClickFirstAccept", localPlayer, id)
    end, false)
    
    addEventHandler("onClientMouseEnter", but1txt[id], function() if source == but1txt[id] then guiSetAlpha(but1txt[id], 0.5) end end)
    addEventHandler("onClientMouseLeave", but1txt[id], function() if source == but1txt[id] then guiSetAlpha(but1txt[id], 1  ) end end)
end

function buttonz(id, num)
    local ele, str = but2txt, "onClientClickSecondAccept"
    if num == 2 then ele = but2txt str = "onClientClickSecondAccept" end
    if num == 3 then ele = but3txt str = "onClientClickThirdAccept" end
    if num == 4 then ele = but4txt str = "onClientClickFourAccept" end
    addEventHandler("onClientGUIClick", ele[id], function()
        setVisibleAcceptPanel(id, false) 
        triggerEvent(str, localPlayer, id)
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