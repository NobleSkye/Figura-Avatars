vanilla_model.PLAYER:setVisible(false)
models.cirno:setSecondaryRenderType("EYES")

pose = false

-- Jimmy Anims: https://github.com/JimmyHelp/JimmyAnims
local anims = require("JimmyAnims")
anims(animations.cirno)

function events.entity_init()
end

function events.tick()   
    if pose then
        animations.cirno.fly:setPlaying(not pose)
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
    sounds:playSound("fumo",player:getPos())
end

local playsoundaction = mainPage:newAction()
    :title("Fumo Sound")
    :item("minecraft:note_block")
    :onLeftClick(pings.playfumosound)

--Toggles pose animation
function pings.posetoggle(state)
    pose = not pose
    animations.cirno.pose:setPlaying(state) 
end

local poseaction = mainPage:newAction()
    :title("Enable Pose")
    :toggleTitle("Disable Pose")
    :item("armor_stand")
    :toggleItem("barrier")
    :setOnToggle(pings.posetoggle) 
