local width, height = guiGetScreenSize()
local phonex, phoney = width-340, height-540
local phonew, phoneh = 275, 420
local screenpx, screenpy = 13, 38
    
local openTimer, closeTimer
function closeTopbar()
    if isTimer(closeTimer) then return false end --If timer in process, then return false
    
    guiBringToFront(topmover)
    guiBringToFront(toppanel)
    
    local posX, posY = guiGetPosition(topmover, false) --Find positions
    posY = posY + 42 --Remove 21pix for move zone
    
    local getMod = math.fmod(posY, 42) --Add to moving
    local timerNumber =  math.abs( (posY-getMod) /42 )+1 --Timer count
    
    local counts = 1
    closeTimer = setTimer(function()
        local sizeW, sizeH = guiGetSize(toppanel, false) --Find size of notbar
        if sizeH <= 0 then 
            guiSetPosition(topmover, 0, 0, false) --Move topbar mover to start pos
            guiSetSize(toppanel, sizeW, 0, false) --Resize notbar to start size
            killTimer(closeTimer) --Stop moving when position setted to start pos
        end 
        
        if sizeH >= 0 and sizeH < 7 then
            guiSetAlpha(topmover, 0)
            guiSetAlpha(toppanel, 0)
        elseif sizeH >= 7 and sizeH < 14 then
            guiSetAlpha(topmover, 0.1)
            guiSetAlpha(toppanel, 0.1)
        elseif sizeH >= 14 and sizeH < 21 then
            guiSetAlpha(topmover, 0.3)
            guiSetAlpha(toppanel, 0.3)
        elseif sizeH >= 21 and sizeH < 28 then
            guiSetAlpha(topmover, 0.4)
            guiSetAlpha(toppanel, 0.4)
        elseif sizeH >= 28 and sizeH < 35 then
            guiSetAlpha(topmover, 0.5)
            guiSetAlpha(toppanel, 0.5)
        elseif sizeH >= 35 and sizeH < 42 then
            guiSetAlpha(topmover, 0.6)
            guiSetAlpha(toppanel, 0.6)
        elseif sizeH >= 42 and sizeH < 49 then
            guiSetAlpha(topmover, 0.7)
            guiSetAlpha(toppanel, 0.7)
        elseif sizeH >= 49 and sizeH < 56 then
            guiSetAlpha(topmover, 0.8)
            guiSetAlpha(toppanel, 0.8)
        elseif sizeH >= 56 and sizeH < 63 then
            guiSetAlpha(topmover, 0.9)
            guiSetAlpha(toppanel, 0.9)
        elseif sizeH >= 63 then
            guiSetAlpha(topmover, 1)
            guiSetAlpha(toppanel, 1)
        end
        
        local newPosX, newPosY = guiGetPosition(topmover, false)
        if counts == 1 then
            guiSetPosition(topmover, newPosX, newPosY-getMod, false) --Move topbar mover down on mod position
            guiSetSize(toppanel, sizeW, sizeH-getMod, false) --Resize notbar down on mod position
        else
            guiSetPosition(topmover, newPosX, newPosY > 0 and newPosY-42 or 0, false) --Set new positions to topbar mover
            guiSetSize(toppanel, sizeW, sizeH > 0 and sizeH-42 or 0, false) -- Resize notbar
        end 
        counts = counts + 1
    end, 50, timerNumber)
end

function openTopbar()
    if isTimer(openTimer) then return false end --If timer in process, then return false
    
    guiBringToFront(topmover)
    guiBringToFront(toppanel)
    
    local posX, posY = guiGetPosition(topmover, false) --Find positions
    posY = posY + 42 --Remove 21pix for move zone
    if posY ~= phoneh then posY = posY-phoneh end  --If Y not Phone Height, then set Y little 
    
    local getMod = math.fmod(posY, 42) --Add to moving
    local timerNumber =  math.abs( (posY-getMod) /42 )+1 --Timer count
    
    local counts = 1
    openTimer = setTimer(function()
        local sizeW, sizeH = guiGetSize(toppanel, false) --Find size of notbar
        if sizeH >= phoneh - 21 then 
            guiSetPosition(topmover, 0, phoneh-21, false) --Move topbar mover to finish pos
            guiSetSize(toppanel, sizeW, phoneh-21, false) --Resize notbar to finish size
            killTimer(openTimer) --Stop moving when position setted to last
        end 
        
        if sizeH >= 0 and sizeH < 7 then
            guiSetAlpha(topmover, 0)
            guiSetAlpha(toppanel, 0)
        elseif sizeH >= 7 and sizeH < 14 then
            guiSetAlpha(topmover, 0.1)
            guiSetAlpha(toppanel, 0.1)
        elseif sizeH >= 14 and sizeH < 21 then
            guiSetAlpha(topmover, 0.3)
            guiSetAlpha(toppanel, 0.3)
        elseif sizeH >= 21 and sizeH < 28 then
            guiSetAlpha(topmover, 0.4)
            guiSetAlpha(toppanel, 0.4)
        elseif sizeH >= 28 and sizeH < 35 then
            guiSetAlpha(topmover, 0.5)
            guiSetAlpha(toppanel, 0.5)
        elseif sizeH >= 35 and sizeH < 42 then
            guiSetAlpha(topmover, 0.6)
            guiSetAlpha(toppanel, 0.6)
        elseif sizeH >= 42 and sizeH < 49 then
            guiSetAlpha(topmover, 0.7)
            guiSetAlpha(toppanel, 0.7)
        elseif sizeH >= 49 and sizeH < 56 then
            guiSetAlpha(topmover, 0.8)
            guiSetAlpha(toppanel, 0.8)
        elseif sizeH >= 56 and sizeH < 63 then
            guiSetAlpha(topmover, 0.9)
            guiSetAlpha(toppanel, 0.9)
        elseif sizeH >= 63 then
            guiSetAlpha(topmover, 1)
            guiSetAlpha(toppanel, 1)
        end
        
        local newPosX, newPosY = guiGetPosition(topmover, false) --Get new positions of mover
        
        if counts == 1 then 
            counts = 0
            guiSetPosition(topmover, newPosX, newPosY-getMod+21, false) --Move topbar mover down on mod position
            guiSetSize(toppanel, sizeW, sizeH-getMod+21, false) --Resize notbar down on mod position
        else
            guiSetPosition(topmover, newPosX, newPosY > phoneh-21 and newPosY-42 or newPosY+42, false) --Set new positions to topbar mover
            guiSetSize(toppanel, sizeW, sizeH > phoneh-21 and sizeH-42 or sizeH+42, false) -- Resize notbar
        end
    end, 50, timerNumber)
    
end

local clicked = false
local setNewPosition = 0
local month =  {"January", "February", "March", "April" , "May", "June", "July", "August", "September", "October", "November", "December"}
local months = {"Январь",  "Февраль" , "Март" , "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь" , "Октябрь", "Ноябрь"  , "Декабрь" }
--local phone, desktop, statusbar, topmover, toppanel, notbarinfo, timetopbar, timenotbar, datenotbar, montnotbar 
addEventHandler("onClientResourceStart", root,
    function(res)
        if res ~= getThisResource() then return false end
        
        --local font = guiCreateFont("fonts/bold.ttf", 10)
        
        phone = guiCreateStaticImage(phonex, phoney, 300, 500, "images/phonew.png", false)
        desktop = guiCreateStaticImage(screenpx, screenpy, phonew, phoneh, "images/element.png", false, phone)
        guiSetProperty(desktop, "ImageColours", "tl:AAFF0000 tr:AA00FF00 bl:AA6600FF br:AA0000FF")
        
        statusbar = guiCreateStaticImage(0, 0, phonew, 20, "images/top.png", false, desktop)
        guiSetProperty(statusbar, "ImageColours", "tl:FF222222 tr:FF222222 bl:FF222222 br:FF222222")
        
        topmover = guiCreateStaticImage(0, 0, phonew, 21, "images/element.png", false, desktop)
        guiSetProperty(topmover, "ImageColours", "tl:44222222 tr:44222222 bl:00000000 br:00000000") --"tl:FFBBBBBB tr:FFBBBBBB bl:FFBBBBBB br:FFBBBBBB"
        guiSetAlpha(topmover, 0)
        
        toppanel = guiCreateStaticImage(0, 0, phonew, 0, "images/element.png", false, desktop)
        guiSetProperty(toppanel, "ImageColours", "tl:44222222 tr:44222222 bl:44222222 br:44222222")
        guiSetAlpha(toppanel, 0)
        
        otherthings = guiCreateStaticImage(0.05, 0, 0.9, 1, "images/element.png", true, toppanel)
        guiSetProperty(otherthings, "ImageColours", "tl:55AAAAAA tr:55AAAAAA bl:01AAAAAA br:01AAAAAA") 
        guiSetEnabled(otherthings, false)
        guiMoveToBack(otherthings)
        
        notbarinfo = guiCreateStaticImage(0, 0, phonew, 40, "images/element.png", false, toppanel)
        guiSetProperty(notbarinfo, "ImageColours", "tl:FF555555 tr:FF555555 bl:AA333333 br:AA333333")
        
        timetopbar = guiCreateLabel(0, 0, phonew, 20, "12:30", false, statusbar)
        guiLabelSetHorizontalAlign(timetopbar, "center")
        guiLabelSetVerticalAlign(timetopbar, "center")
        guiSetFont(timetopbar, guiCreateFont("fonts/bold.ttf", 10))
        guiLabelSetColor(timetopbar, 200, 160, 160)
        
        location = guiCreateLabel(0, 0, phonew, 20, "Location", false, timetopbar)
        guiLabelSetHorizontalAlign(location, "right")
        guiLabelSetVerticalAlign(location, "center")
        guiSetFont(location, guiCreateFont("fonts/bold.ttf", 9))
        guiLabelSetColor(location, 200, 160, 160)
        
        battery = guiCreateStaticImage(0, 1, 19, 18, "images/battery.png", false, statusbar)
        guiSetProperty(battery, "ImageColours", "tl:FFC8A0A0 tr:FFC8A0A0 bl:FFC8A0A0 br:FFC8A0A0")
        
        wifi = guiCreateStaticImage(19, 2, 17, 16, "images/wifi.png", false, statusbar)
        guiSetProperty(wifi, "ImageColours", "tl:FFC8A0A0 tr:FFC8A0A0 bl:FFC8A0A0 br:FFC8A0A0")
        
        threeg = guiCreateStaticImage(36, 1, 19, 18, "images/thr.png", false, statusbar)
        guiSetProperty(threeg, "ImageColours", "tl:FFC8A0A0 tr:FFC8A0A0 bl:FFC8A0A0 br:FFC8A0A0")
        
        timenotbar = guiCreateLabel(5, 0, 70, 40, "22:22", false, notbarinfo)
        guiLabelSetHorizontalAlign(timenotbar, "center")
        guiLabelSetVerticalAlign(timenotbar, "center")
        guiSetFont(timenotbar, guiCreateFont("fonts/regular.ttf", 22))
        guiLabelSetColor(timenotbar, 230, 230, 230)
        
        datenotbar = guiCreateLabel(80, 4, 60, 20, "23, 2014", false, notbarinfo)
        guiLabelSetVerticalAlign(datenotbar, "center")
        guiSetFont(datenotbar, guiCreateFont("fonts/medium.ttf", 11))
        guiLabelSetColor(datenotbar, 230, 230, 230)
        
        montnotbar = guiCreateLabel(80, 20, 60, 20, "November", false, notbarinfo)
        guiLabelSetVerticalAlign(montnotbar, "top")
        guiSetFont(montnotbar, guiCreateFont("fonts/medium.ttf", 9))
        guiLabelSetColor(montnotbar, 230, 230, 230)
        
        scrollernots = guiCreateScrollPane(0, 40, phonew, phoneh-60, false, toppanel)
        changernots = guiCreateStaticImage(0, 0, phonew, 0, "images/element.png", false, scrollernots)
        guiSetProperty(changernots, "ImageColours", "tl:77111111 tr:77111111 bl:77111111 br:77111111")
        
        notificationclear = guiCreateStaticImage(phonew-40, 0, 40, 40, "images/clear.png", false, notbarinfo)
        guiSetProperty(notificationclear, "ImageColours", "tl:FF999999 tr:FF999999 bl:FF999999 br:FF999999")
        guiSetVisible(notificationclear, false)
        
        addEventHandler("onClientMouseEnter", notificationclear, function() if source == notificationclear then guiSetAlpha(notificationclear, 0.5) end end)
        addEventHandler("onClientMouseLeave", notificationclear, function() if source == notificationclear then guiSetAlpha(notificationclear, 1) end end)
        
        addEventHandler("onClientGUIClick", notificationclear, function()
        
            if source ~= notificationclear then return 1 end
            
            for i = 1, getNotificationCount() do 
                setTimer(function()
                    destroyNotification(getNotificationTable()[i]) 
                end, 100*i, 1)
            end
            
            
            
        end, false)
        
        addEventHandler("onClientGUIMouseDown", root, function(Button, _, ScrollY)
            if source ~= topmover then return 1 end
            if Button ~= "left" then return 1 end
            
            guiBringToFront(topmover)
            guiBringToFront(toppanel)
            
            clicked = true
            
            local _, ScrollPosition = guiGetPosition(topmover, false)
            setNewPosition = ScrollY-ScrollPosition
        end)
        
        addEventHandler("onClientGUIMouseUp", root, function()
            if source ~= topmover then return 1 end
            
            guiBringToFront(topmover)
            guiBringToFront(toppanel)
            
            local _, ScrollPosition = guiGetPosition(topmover, false)
            
            if clicked then
                if ScrollPosition < 210 then closeTopbar()
                else openTopbar() end
            else
                if ScrollPosition > 210 then closeTopbar()
                else openTopbar() end
            end
            
            clicked = false
        end)
        
        addEventHandler("onClientCursorMove", root, function(_, _, cursorPosX, cursorPosY)
        
            if not clicked then return 1; end
            
            local phoneX, phoneY = guiGetPosition(phone, false) --Get Phone positions
            local _, newYPos     = guiGetPosition(toppanel, false) --Find notbar Y position
            local getElementX    = guiGetPosition(topmover, false) --Find mover X position
            local getPanelX      = guiGetSize(toppanel, false) --Find notbar width
            
            local findPosition = cursorPosY-setNewPosition --Get new position with cursor positions
            if findPosition < 0 then --Set it to zero, when position < 0
                findPosition = 0 
                setCursorPosition(cursorPosX, findPosition+5+phoneY+38)
            end 
            if findPosition > phoneh-21 then --Set positions to end position when position-21 > screensize
                findPosition = phoneh-21 
                setCursorPosition(cursorPosX, findPosition+5+phoneY+38)
            end 
            
            if cursorPosX < phoneX+15 then setCursorPosition(phoneX+17, findPosition+5+phoneY+38) end
            if cursorPosX > phoneX+10+phonew then setCursorPosition(phoneX+phonew, findPosition+5+phoneY+38) end
            
            if findPosition >= 0 and findPosition < 7 then
                guiSetAlpha(topmover, 0)
                guiSetAlpha(toppanel, 0)
            elseif findPosition >= 7 and findPosition < 14 then
                guiSetAlpha(topmover, 0.1)
                guiSetAlpha(toppanel, 0.1)
            elseif findPosition >= 14 and findPosition < 21 then
                guiSetAlpha(topmover, 0.3)
                guiSetAlpha(toppanel, 0.3)
            elseif findPosition >= 21 and findPosition < 28 then
                guiSetAlpha(topmover, 0.4)
                guiSetAlpha(toppanel, 0.4)
            elseif findPosition >= 28 and findPosition < 35 then
                guiSetAlpha(topmover, 0.5)
                guiSetAlpha(toppanel, 0.5)
            elseif findPosition >= 35 and findPosition < 42 then
                guiSetAlpha(topmover, 0.6)
                guiSetAlpha(toppanel, 0.6)
            elseif findPosition >= 42 and findPosition < 49 then
                guiSetAlpha(topmover, 0.7)
                guiSetAlpha(toppanel, 0.7)
            elseif findPosition >= 49 and findPosition < 56 then
                guiSetAlpha(topmover, 0.8)
                guiSetAlpha(toppanel, 0.8)
            elseif findPosition >= 56 and findPosition < 63 then
                guiSetAlpha(topmover, 0.9)
                guiSetAlpha(toppanel, 0.9)
            elseif findPosition >= 63 then
                guiSetAlpha(topmover, 1)
                guiSetAlpha(toppanel, 1)
            end
                
            guiSetPosition(topmover, getElementX, findPosition, false) --Set new positions to mover
            guiSetSize(toppanel, getPanelX, findPosition-newYPos, false) --Set new size to notbar
        end)
        
    end)
    
addEventHandler("onClientRender", root, function()
    if not guiGetVisible(phone) then return false end
    guiSetText(timetopbar, string.format("%i:%.2i", getRealTime().hour, getRealTime().minute))
    guiSetText(timenotbar, string.format("%.2i:%.2i", getRealTime().hour, getRealTime().minute))
    guiSetText(datenotbar, string.format("%i, %i", getRealTime().monthday, getRealTime().year+1900))
    guiSetText(montnotbar, month[(getRealTime().month)+1])
    
    local x, y, z = getElementPosition(localPlayer)
    guiSetText(location, getZoneName(x, y, z))
end)
    
function ocTopbar()
    local _, ScrollPosition = guiGetPosition(topmover, false)
    if ScrollPosition < 210 then openTopbar()
    else closeTopbar() end
end

function desktopNotbarType(bool)
    if bool == true or bool == "desktop" then guiStaticImageLoadImage(statusbar, "images/top.png")
    else guiStaticImageLoadImage(statusbar, "images/element.png") end
    guiStaticImageLoadImage(battery, "images/battery.png")
    guiStaticImageLoadImage(wifi, "images/wifi.png")
    guiStaticImageLoadImage(threeg, "images/thr.png")
end

function getNotbar()
    return toppanel
end
 
function getNotbarMover()
    return topmover
end

function getStatusbar()
    return statusbar
end

function getNotificationPane()
    return scrollernots
end

function getNotificationZone()
    return changernots
end

function getDesktop()
    return desktop
end

function getPhoneSize()
    return phonew, phoneh
end

function getPhonePosition()
    return phonex, phoney
end

function getScreenPosition()
    return screenpx, screenpy
end

function getRealScreenPosition()
    return phonex+screenpx, phoney+screenpy
end

function getNotificationClear()
    return notificationclear
end

function getPhone()
    return phone
end

function getNotificationMenuSize()
    local _, h = guiGetSize(changernots, false)
    return h
end

addEvent("setSize", true)
addEventHandler("setSize", root,
    function(el)
        local w, h = guiGetSize(changernots, false)
        guiSetSize(changernots, w, h+el, false)
    end)
