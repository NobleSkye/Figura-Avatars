---@type Sound[]
local soundboard = {}
local custom_sounds = sounds:getCustomSounds()
for i = 1, #custom_sounds do
    soundboard[i] = sounds[custom_sounds[i]]:attenuation(2)
end

if not next(soundboard) then return end

function pings.playSound(id, state)
    events.RENDER:remove("sound_"..id)
    if state then
        soundboard[id]:stop():play()
        events.RENDER:register(function (delta)
            soundboard[id]:pos(player:getPos(delta))
            if not soundboard[id]:isPlaying() then
                events.RENDER:remove("sound_"..id)
            end
        end, "sound_"..id)
    else
        soundboard[id]:stop()
    end
end

if not host:isHost() then return end

local page = action_wheel:newPage()

---@type { page: Page?, rightClick: ActionWheelAPI.clickFunc }
local old_wheel = {}
local function back()
    action_wheel:setPage(old_wheel.page)
    action_wheel.rightClick = old_wheel.right
end

page:newAction():title("§lBack§r"):item("arrow"):color(0.8,0.8,0.8):onLeftClick(back)

---@param i integer
---@param action Action
---@param sound Sound
---@return fun(state: boolean)
local function toggle(i, action, sound)
    return function(state)
        pings.playSound(i, state)
        events.TICK:register(function ()
            if sound:isPlaying() then return end
            events.TICK:remove("sound_"..i)
            action:setToggled(false)
        end, "sound_"..i)
    end
end

---@type string[]
local discs = { "chirp", "blocks", "13", "far", "cat", "ward", "otherside", "wait", "mall", "mellohi", "strad" }
for i = 1, #soundboard do
    local sound = soundboard[i]
    local action = page:newAction()
    action:title(sound:getSubtitle())
    action:item("music_disc_"..discs[((i - 1) % #discs) + 1])
    action:onToggle(toggle(i, action, sound))
end

local n_actions = #soundboard + 1
while n_actions % 8 ~= 0 do
    n_actions = n_actions + 1
    page:newAction():hoverColor(0,0,0)
end

return action_wheel:newAction():title("Soundboard"):item("jukebox"):onLeftClick(function ()
    old_wheel.page = action_wheel:getCurrentPage()
    old_wheel.right = action_wheel.rightClick
    action_wheel.rightClick = back
    action_wheel:setPage(page)
end)