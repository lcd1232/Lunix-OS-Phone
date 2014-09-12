local width, height = guiGetScreenSize()
local phonex, phoney = width-340, height-542
local phonew, phoneh = 275, 420
local screenpx, screenpy = 13, 38
    
local openTimer, closeTimer

local renderin = false
local getModClose = 0
function closeTopbar()
    if renderin then return false end --If timer in process, then return false
    
    guiBringToFront(topmover)
    guiBringToFront(toppanel)
    
    local _, posY = guiGetPosition(topmover, false) --Find positions
    posY = posY + 42 --Remove 21pix for move zone
    
    getModClose = math.fmod(posY, 18) --Add to moving
    
    renderin = true
end

local countsClose = 1
addEventHandler("onClientRender", root, function()
    if not renderin then return false end
    local sizeW, sizeH = guiGetSize(toppanel, false) --Find size of notbar
        
    if sizeH == 0 then
        guiSetAlpha(topmover, 0)
        guiSetAlpha(toppanel, 0)
    elseif sizeH > 0 then
        guiSetAlpha(topmover, 1)
        guiSetAlpha(toppanel, 1)
    end
    
    guiSetAlpha(statusbar, guiGetAlpha(statusbar)+0.1)
        
    if sizeH <= 0 then 
        guiSetPosition(topmover, 0, 0, false) --Move topbar mover to start pos
        guiSetSize(toppanel, sizeW, 0, false) --Resize notbar to start size
        renderin = false
        guiSetAlpha(statusbar, 1)
        cancelEvent() --Stop moving when position setted to start pos
        return 1
    end 
        
    local newPosX, newPosY = guiGetPosition(topmover, false)
    if countsClose == 1 then
        guiSetPosition(topmover, newPosX, newPosY-getModClose, false) --Move topbar mover down on mod position
        guiSetSize(toppanel, sizeW, sizeH-getModClose, false) --Resize notbar down on mod position
    else
        guiSetPosition(topmover, newPosX, newPosY > 0 and newPosY-18 or 0, false) --Set new positions to topbar mover
        guiSetSize(toppanel, sizeW, sizeH > 0 and sizeH-18 or 0, false) -- Resize notbar
    end 
    countsClose = countsClose + 1
end)

local opening = false
local getModOpen = 0
function openTopbar()
    if opening then return false end --If timer in process, then return false
    opening = true
    
    guiBringToFront(topmover)
    guiBringToFront(toppanel)
    
    local posX, posY = guiGetPosition(topmover, false) --Find positions
    posY = posY + 42 --Remove 21pix for move zone
    if posY ~= phoneh then posY = posY-phoneh end  --If Y not Phone Height, then set Y little 
    
    local getModOpen = math.fmod(posY, 18) --Add to moving
end
local countsOpen = 1
addEventHandler("onClientRender", root, function()
    if not opening then return false end
        
    local sizeW, sizeH = guiGetSize(toppanel, false) --Find size of notbar
        
    if sizeH == 0 then
        guiSetAlpha(topmover, 0)
        guiSetAlpha(toppanel, 0)
    elseif sizeH > 0 then
        guiSetAlpha(topmover, 1)
        guiSetAlpha(toppanel, 1)
    end
    
    guiSetAlpha(statusbar, guiGetAlpha(statusbar)-0.1)
        
    if sizeH >= phoneh - 21 then 
        guiSetPosition(topmover, 0, phoneh-21, false)  --Move topbar mover to finish pos
        guiSetSize(toppanel, sizeW, phoneh-21, false)  --Resize notbar to finish size
        
        opening = false
        guiSetAlpha(statusbar, 0)
        cancelEvent() --Stop moving when position setted to start pos
        return 1
    end 
        
    local newPosX, newPosY = guiGetPosition(topmover, false) --Get new positions of mover
        
    if countsOpen == 1 then 
        countsOpen = 0
        guiSetPosition(topmover, newPosX, newPosY-getModOpen, false)  --Move topbar mover down on mod position
        guiSetSize(toppanel, sizeW, sizeH-getModOpen, false)  --Resize notbar down on mod position
    else
        guiSetPosition(topmover, newPosX, newPosY > phoneh-21 and newPosY-18 or newPosY+18, false)  --Set new positions to topbar mover
        guiSetSize(toppanel, sizeW, sizeH > phoneh-21 and sizeH-18 or sizeH+18, false)  -- Resize notbar
    end
end)

local clicked = false
local setNewPosition = 0
local month =  {"January", "February", "March", "April" , "May", "June", "July", "August", "September", "October", "November", "December"}
local months = {"Январь",  "Февраль" , "Март" , "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь" , "Октябрь", "Ноябрь"  , "Декабрь" }
--local phone, desktop, statusbar, topmover, toppanel, notbarinfo, timetopbar, timenotbar, datenotbar, montnotbar 
addEventHandler("onClientResourceStart", root,
    function(res)
        if res ~= getThisResource() then return false end
        
        --local font = guiCreateFont("fonts/bold.ttf", 10)
        
        phone = guiCreateStaticImage(phonex, phoney, 300, 502, "images/phonew.png", false)
        
        startbutton = guiCreateStaticImage(244, 3, 35, 5, "images/element.png", false, phone)
        guiSetAlpha(startbutton, 0)
        
        desktop = guiCreateStaticImage(screenpx, screenpy, phonew, phoneh, "images/3.png", false, phone)
        --guiSetProperty(desktop, "ImageColours", "tl:AAFF0000 tr:AA00FF00 bl:AA6600FF br:AA0000FF")
        
        
        
        
        statusbar = guiCreateStaticImage(0, 0, phonew, 20, "images/element.png", false, desktop)
        guiSetProperty(statusbar, "ImageColours", "tl:55222222 tr:55222222 bl:55222222 br:55222222")
        
        topmover = guiCreateStaticImage(0, 0, phonew, 21, "images/element.png", false, desktop)
        guiSetProperty(topmover, "ImageColours", "tl:CC222222 tr:CC222222 bl:CC222222 br:CC222222") --"tl:44222222 tr:44222222 bl:00000000 br:00000000"
        
        scroller = guiCreateStaticImage(phonew/2-25, 0, 50, 21, "images/scroll.png", false, topmover)
        guiSetProperty(scroller, "ImageColours", "tl:88999999 tr:88999999 bl:88999999 br:88999999")
        guiSetEnabled(scroller, false)
        
        guiSetAlpha(topmover, 0)
        
        toppanel = guiCreateStaticImage(0, 0, phonew, 0, "images/element.png", false, desktop)
        guiSetProperty(toppanel, "ImageColours", "tl:CC222222 tr:CC222222 bl:CC222222 br:CC222222")
        guiSetAlpha(toppanel, 0)
        
        notbarinfo = guiCreateStaticImage(0, 0, phonew, 40, "images/element.png", false, toppanel)
        guiSetProperty(notbarinfo, "ImageColours", "tl:00222222 tr:00222222 bl:00222222 br:00222222")
        
        timetopbar = guiCreateLabel(0, 0, phonew, 20, "12:30", false, statusbar)
        guiLabelSetHorizontalAlign(timetopbar, "center")
        guiLabelSetVerticalAlign(timetopbar, "center")
        guiSetFont(timetopbar, guiCreateFont("fonts/bold.ttf", 10))
        guiLabelSetColor(timetopbar, 247, 247, 247)
        
        location = guiCreateLabel(0, 0, phonew-4, 20, "Location", false, timetopbar)
        guiLabelSetHorizontalAlign(location, "right")
        guiLabelSetVerticalAlign(location, "center")
        guiSetFont(location, guiCreateFont("fonts/bold.ttf", 9))
        guiLabelSetColor(location, 247, 247, 247)
        
        battery = guiCreateStaticImage(0, 1, 19, 18, "images/battery.png", false, statusbar)
        guiSetProperty(battery, "ImageColours", "tl:FFF7F7F7 tr:FFF7F7F7 bl:FFF7F7F7 br:FFF7F7F7")
        
        wifi = guiCreateStaticImage(19, 2, 17, 16, "images/wifi.png", false, statusbar)
        guiSetProperty(wifi, "ImageColours", "tl:FFF7F7F7 tr:FFF7F7F7 bl:FFF7F7F7 br:FFF7F7F7")
        
        threeg = guiCreateStaticImage(36, 1, 19, 18, "images/thr.png", false, statusbar)
        guiSetProperty(threeg, "ImageColours", "tl:FFF7F7F7 tr:FFF7F7F7 bl:FFF7F7F7 br:FFF7F7F7")
        
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
        
        addEventHandler("onClientGUIClick", startbutton, function()
            if source ~= startbutton then return 1 end
            ocPhone()
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
            
            if findPosition == 0 then
                guiSetAlpha(topmover, 0)
                guiSetAlpha(toppanel, 0)
            --[[elseif findPosition >= 7 and findPosition < 14 then
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
                guiSetAlpha(toppanel, 0.9)]]
            elseif findPosition > 0 then
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

function setEnabledNotificationPanel(bool)
    if not bool or (bool ~= true and bool ~= false) then bool = not guiGetEnabled(topmover) end
    guiSetEnabled(topmover, bool)
    closeTopbar()
end

local startExitTimer
function startPhone()
    if guiGetAlpha(desktop) == 1 then return 1 end
    if isTimer(startExitTimer) then return false end
    
    guiSetVisible(desktop, true)
    showLockScreen()
    
    startExitTimer = setTimer(function()
        guiSetAlpha(desktop, guiGetAlpha(desktop)+0.1)
    end, 50, 10)
end
function stopPhone()
    if guiGetAlpha(desktop) == 0 then return 1 end
    if isTimer(startExitTimer) then return false end
    
    local id = 0
    startExitTimer = setTimer(function()
        id = id+1
        guiSetAlpha(desktop, guiGetAlpha(desktop)-0.1)
        if id >= 11 then guiSetVisible(desktop, false) end
    end, 50, 11)
end
function ocPhone()
    if guiGetAlpha(desktop) == 0 then startPhone()
    else stopPhone() end
end
    
    
function ocTopbar()
    local _, ScrollPosition = guiGetPosition(topmover, false)
    if ScrollPosition < 210 then openTopbar()
    else closeTopbar() end
end

function desktopNotbarType(bool)
    
    if bool == true or bool == "desktop" then guiSetProperty(statusbar, "ImageColours", "tl:99222222 tr:99222222 bl:99222222 br:99222222")
    else guiSetProperty(statusbar, "ImageColours", "tl:FF222222 tr:FF222222 bl:FF222222 br:FF222222") end
    --if bool == true or bool == "desktop" then guiStaticImageLoadImage(statusbar, "images/top.png")
    --else guiStaticImageLoadImage(statusbar, "images/element.png") end
    --guiStaticImageLoadImage(battery, "images/battery.png")
    --guiStaticImageLoadImage(wifi, "images/wifi.png")
    --guiStaticImageLoadImage(threeg, "images/thr.png")
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

local colorChanger
function colorChange(element, fromred, fromgreen, fromblue, tored, togreen, toblue, time)
    if not isElement(element) then return false end
    if isTimer(colorChanger) then return false end
    
    if fromred < 0 or fromred > 255 or not tonumber(fromred) then fromred = 255 end
    if fromgreen < 0 or fromgreen > 255 or not tonumber(fromgreen) then fromgreen = 255 end
    if fromblue < 0 or fromblue > 255 or not tonumber(fromblue) then fromblue = 255 end
    if tored < 0 or tored > 255 or not tonumber(tored) then tored = 255 end
    if togreen < 0 or togreen > 255 or not tonumber(togreen) then togreen = 255 end
    if toblue < 0 or toblue > 255 or not tonumber(toblue) then toblue = 255 end
    if time < 50 or time > 100 or not tonumber(time) then time = 50 end
    
    local colores = tonumber(string.format("%i", math.sqrt(time)))
    
    local redpog, greenpog, bluepog
    redpog = math.fmod(math.abs(fromred-tored), colores) 
    greenpog = math.fmod(math.abs(fromgreen-togreen), colores) 
    bluepog = math.fmod(math.abs(fromblue-toblue), colores) 
    
    local numeric = 0
    colorChanger = setTimer(function()
        if numeric == 0 then
            numeric = 1
            if fromred > tored then fromred = fromred-redpog end
            if fromgreen > togreen then fromgreen = fromgreen-greenpog end
            if fromblue > toblue then fromblue = fromblue-bluepog end
            
            if fromred < tored then fromred = fromred+redpog end
            if fromgreen < togreen then fromgreen = fromgreen+greenpog end
            if fromblue < toblue then fromblue = fromblue+bluepog end
        else
            if fromred > tored then fromred = fromred-colores end
            if fromgreen > togreen then fromgreen = fromgreen-colores end
            if fromblue > toblue then fromblue = fromblue-colores end
            
            if fromred < tored then fromred = fromred+colores end
            if fromgreen < togreen then fromgreen = fromgreen+colores end
            if fromblue < toblue then fromblue = fromblue+colores end
        end
        
        if getElementType(element) == "gui-staticimage" then 
            local st = string.format("tl:FF%.2x%.2x%.2x tr:FF%.2x%.2x%.2x bl:FF%.2x%.2x%.2x br:FF%.2x%.2x%.2x", fromred, fromgreen, fromblue, fromred, fromgreen, fromblue, fromred, fromgreen, fromblue, fromred, fromgreen, fromblue)
            guiSetProperty(element, "ImageColours", st)
        elseif getElementType(element) == "gui-label" then
            guiLabelSetColor(element, fromred, fromgreen, fromblue)
        else
            local st = string.format("tl:FF%.2x%.2x%.2x tr:FF%.2x%.2x%.2x bl:FF%.2x%.2x%.2x br:FF%.2x%.2x%.2x", fromred, fromgreen, fromblue, fromred, fromgreen, fromblue, fromred, fromgreen, fromblue, fromred, fromgreen, fromblue)
            guiSetProperty(element, "NormalTextColour", st)
        end
        if fromred == tored and fromgreen == togreen and fromblue == toblue then killTimer(colorChanger) end
    end, time, 0)

end

addEvent("setSize", true)
addEventHandler("setSize", root,
    function(el)
        local w, h = guiGetSize(changernots, false)
        guiSetSize(changernots, w, h+el, false)
    end)