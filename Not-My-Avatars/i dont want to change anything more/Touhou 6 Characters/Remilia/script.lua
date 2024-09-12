vanilla_model.PLAYER:setVisible(false)
models.remilia:setSecondaryRenderType("EYES")


pose = false

-- Jimmy Anims: https://github.com/JimmyHelp/JimmyAnims
local anims = require("JimmyAnims")
anims(animations.remilia)

function events.entity_init()
end

function events.tick() 
    if pose then
        animations.remilia.fly:setPlaying(not pose)
        animations.remilia.sprint:setPlaying(not pose)
    end
end

function events.render(delta, context)
end

function events.skull_render(delta, blockstate, item, entity, context)
end

function events.item_render(item)
    if item.id:find("trident") then
        return models.remilia.ItemSpear --Change this if you want
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

--Toggles the hat
function pings.hatToggle(state)
    models.remilia.Head.Hat:setVisible(not state)
end

local hataction = mainPage:newAction()
    :title("Remove Hat")
    :toggleTitle("Show Hat")
    :item("barrier")
    :toggleItem("leather_helmet")
    :setOnToggle(pings.hatToggle) 

--Toggles fly animation
function pings.flytoggle(state)
    pose = not pose
    vanilla_model.ELYTRA:setVisible(not state) --I couldn't fix the elytra position so I just hid it :/
    animations.remilia.pose:setPlaying(state)
end

local flyposeaction = mainPage:newAction()
    :title("Enable Flying Pose")
    :toggleTitle("Disable Flying Pose")
    :item("feather")
    :toggleItem("barrier")
    :setOnToggle(pings.flytoggle) 
