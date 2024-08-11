vanilla_model.PLAYER:setVisible(false)

pose = false

-- Jimmy Anims: https://github.com/JimmyHelp/JimmyAnims
local anims = require("JimmyAnims")
anims(animations.rumia)

function events.entity_init()
end

function events.tick()   
    if pose then
        animations.rumia.fly:setPlaying(not pose)
    end
end

function events.render(delta, context)
end

function events.skull_render(delta, blockstate, item, entity, context)
end


------------------------ Action Wheel ----------------------------
local mainPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

--Plays fumo sound
function pings.playfumosound()
    pose = not pose
    sounds:playSound("fumo",player:getPos())
end

local playsoundaction = mainPage:newAction()
    :title("Fumo Sound")
    :item("minecraft:note_block")
    :onLeftClick(pings.playfumosound)

--Toggles her T-Pose thing animation
function pings.posetoggle(state)
    animations.rumia.pose:setPlaying(state)
    pose = not pose
end

local poseaction = mainPage:newAction()
    :title("Enable T-Pose")
    :toggleTitle("Disable T-Pose")
    :item("armor_stand")
    :toggleItem("barrier")
    :setOnToggle(pings.posetoggle) 
