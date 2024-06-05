--[[
    ___ _   _ _ _ _ ___ ___ ___ _   _
   |_ -| |_|_'_| v | -_| ._| . | |_| |_
   |___|___||_||_v_|___|_-_|_,_|___|___|
-- ================================================= --
   AFK Nameplate: Rewritten

   A rewrite of my old AFK script, now with less
   hard-coding! Just require this script into
   another and use the function returned.
--]]

-- The amount of ticks before you are "afk"
local afkDelay = 15*20
-- DO NOT MODIFY
local afkTime = 0
local sanitized = nil
local isAFK = nil

-- Initialize some variables when the player is loaded.
events.ENTITY_INIT:register(function()
    local pos = user:getPos()
    local rot = user:getRot()
end)

-- Check if the player hasn't moved. If not, add 1 to their afkTime.
events.TICK:register(function()
    oldPos = pos
    oldRot = rot
    pos = user:getPos()
    rot = user:getRot()
    
    if pos == oldPos and rot == oldRot then afkTime = afkTime + 1 else afkTime = 0 end
end)

-- A ping function that sends the sanitized AFK time to all players.
function pings.sendTime(v)
    isAFK = v
end

-- Check if the sanitized AFK time is different from the one distributed. If so, distribute a new AFK time.
events.TICK:register(function()
    if isAFK then
        isAFK = isAFK + 1
    end

    if host:isHost() then
        if afkTime >= afkDelay then
            sanitized = afkTime
        else
            sanitized = nil
        end

        if (sanitized == nil) ~= (isAFK == nil) then
            pings.sendTime(sanitized)
        end
    end
end, "AFK :: distribute_time")

-- Return the distributed AFK time.
return function()
    return isAFK
end
