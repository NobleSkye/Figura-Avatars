vanilla_model.PLAYER:setVisible(false)

pose = false

-- Jimmy Anims: https://github.com/JimmyHelp/JimmyAnims
local anims = require("JimmyAnims")
anims(animations.sakuya)

function events.entity_init()
end

function events.tick() 
    if pose then
        animations.sakuya.fly:setPlaying(not pose)
    end
end

function events.render(delta, context)
end

function events.skull_render(delta, blockstate, item, entity, context)
end

function events.item_render(item)
    if item.id:find("trident") then
        return models.sakuya.ItemKnife --Change this if you want
    end
end


------------------------ Action Wheel ----------------------------
local mainPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

--Plays fumo sound
function pings.playfumosound()
    sounds:playSound("fumo",player:getPos())
end

local playsoundaction = mainPage:newAction()
    :title("Fumo Sound")
    :item("minecraft:note_block")
    :onLeftClick(pings.playfumosound)


--Toggles fly animation
function pings.flytoggle(state)
    pose = not pose
    vanilla_model.ELYTRA:setVisible(not state) --I couldn't fix the elytra position so I just hid it :/
    animations.sakuya.pose:setPlaying(state)
end

local flyposeaction = mainPage:newAction()
    :title("Enable Flying Pose")
    :toggleTitle("Disable Flying Pose")
    :item("feather")
    :toggleItem("barrier")
    :setOnToggle(pings.flytoggle) 
