-- Local Vars
local mainPage = action_wheel:newPage()
local squapi = require("SquAPI")







-- Hide vanilla models & Other Thingys
vanilla_model.CAPE:setVisible(false)
vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)

models.plushie:setVisible(false)
models.uwu:setVisible(false)


-- Tab Enitiy & List Nameplates
nameplate.LIST:setText("§d Skye :trans:")
nameplate.ENTITY:setText("§d Skye")
nameplate.CHAT:setText("§d Skye")


function pings.waveanim()
    animations.model.wave:play()
  end
  function events.chat_send_message(msg)
    if msg == "o/" then
        pings.waveanim()
      end
    return msg
  end

squapi.smoothHead(
    models.model.root.Torso.head, 
    0.1, 
    1, 
    true
)
squapi.smoothTorso(
    models.model.root.Torso, 
    0.5, 
    0.4
)

function squapi.bouncetowards(current, target, vel, stiff, bounce)
	local bounce = bounce or 0.05
	local stiff = stiff or 0.005	
	local dif = target - current
	vel = vel + ((dif - vel * stiff) * stiff)
	current = (current + vel) + (dif * bounce)
	return current, vel
end




