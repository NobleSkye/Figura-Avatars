vanilla_model.PLAYER:setVisible(false)

pose = false

-- Jimmy Anims: https://github.com/JimmyHelp/JimmyAnims
local anims = require("JimmyAnims")
anims(animations.patchouli)

function events.entity_init()
end

function events.tick() 
    if pose then
        animations.patchouli.fly:setPlaying(not pose)
    end
end

function events.render(delta, context)
end

function events.skull_render(delta, blockstate, item, entity, context)
end

function events.item_render(item)
    if item.id:find("book") then
        return models.patchouli.ItemBook --Change this if you want
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
    models.patchouli.Head.Hat:setVisible(not state)
end

local hataction = mainPage:newAction()
    :title("Remove Hat")
    :toggleTitle("Show Hat")
    :item("barrier")
    :toggleItem("leather_helmet")
    :setOnToggle(pings.hatToggle) 

--Toggles pose animation
function pings.posetoggle(state)
    pose = not pose
    animations.patchouli.pose:setPlaying(state)
end

local flyposeaction = mainPage:newAction()
    :title("Enable Pose")
    :toggleTitle("Disable Pose")
    :item("armor_stand")
    :toggleItem("barrier")
    :setOnToggle(pings.posetoggle) 
