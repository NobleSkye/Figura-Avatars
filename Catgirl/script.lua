--       ___           ___                         ___           ___                    ___           ___           ___                                              
--      /  /\         /  /\          __           /  /\         /  /\                  /  /\         /  /\         /  /\           ___         ___           ___     
--     /  /::\       /  /:/         |  |\        /  /::\       /  /::\                /  /::\       /  /::\       /  /::\         /__/\       /  /\         /__/\    
--    /__/:/\:\     /  /:/          |  |:|      /  /:/\:\     /__/:/\:\              /__/:/\:\     /  /:/\:\     /  /:/\:\        \__\:\     /  /::\        \  \:\   
--   _\_ \:\ \:\   /  /::\____      |  |:|     /  /::\ \:\   _\_ \:\ \:\            _\_ \:\ \:\   /  /:/  \:\   /  /::\ \:\       /  /::\   /  /:/\:\        \__\:\  
--  /__/\ \:\ \:\ /__/:/\:::::\     |__|:|__  /__/:/\:\ \:\ /__/\ \:\ \:\          /__/\ \:\ \:\ /__/:/ \  \:\ /__/:/\:\_\:\   __/  /:/\/  /  /::\ \:\       /  /::\ 
--  \  \:\ \:\_\/ \__\/~|:|~~~~     /  /::::\ \  \:\ \:\_\/ \  \:\ \:\_\/          \  \:\ \:\_\/ \  \:\  \__\/ \__\/~|::\/:/  /__/\/:/~~  /__/:/\:\_\:\     /  /:/\:\
--   \  \:\_\:\      |  |:|        /  /:/~~~~  \  \:\ \:\    \  \:\_\:\             \  \:\_\:\    \  \:\          |  |:|::/   \  \::/     \__\/  \:\/:/    /  /:/__\/
--    \  \:\/:/      |  |:|       /__/:/        \  \:\_\/     \  \:\/:/              \  \:\/:/     \  \:\         |  |:|\/     \  \:\          \  \::/    /__/:/     
--     \  \::/       |__|:|       \__\/          \  \:\        \  \::/                \  \::/       \  \:\        |__|:|~       \__\/           \__\/     \__\/      
--      \__\/         \__\|                       \__\/         \__\/                  \__\/         \__\/         \__\|                                             




-- Local Vars

local squapi = require("SquAPI")
require("CommandAPI")

nameplate.LIST:setText(
    '[{"color":"#fc97fc","text":"ᴜᴡᴜ "},' ..
    '{"color":"#535353","text":"| "},' ..
    '{"color":"#fc97fc","text":"N"},' ..
    '{"color":"#fba8fc","text":"o"},' ..
    '{"color":"#fbb1fc","text":"b"},' ..
    '{"color":"#fcbafc","text":"l"},' ..
    '{"color":"#fcc3fc","text":"e"},' ..
    '{"color":"#fcccfb","text":"S"},' ..
    '{"color":"#fcd4fb","text":"k"},' ..
    '{"color":"#fcdbfb","text":"y"},' ..
    '{"color":"#fce2fb","text":"e"}]'
)

-- Hide vanilla models & Other Thingys
vanilla_model.CAPE:setVisible(false)
vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)



models.plushie:setVisible(false)
models.uwu:setVisible(false)


-- Tab Enitiy & List Nameplates
-- nameplate.LIST:setText("§d Skye :trans:")
-- nameplate.ENTITY:setText("§d Skye")
-- nameplate.CHAT:setText("§d Skye")




function pings.waveanim()
    animations.model.wave:play()
  end
  function events.chat_send_message(msg)
    if msg == "o/" then
        pings.waveanim()
      end
    return msg
  end

  function events.entity_init()
	require("physBoneAPI")
	physBone.physBoobas:setGravity(1)
	physBone.physBoobas:setAirResistance(0)
	physBone.physBoobas:setSpringForce(100)
  end




-- SquAPI Stuff

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

squapi.eye(
	models.model.root.Torso.head.Eyes.right, --element
	1.25, --(.25)leftdistance
	.25, --(1.25)rightdistance
	nil, --(.5)updistance
	nil, --(.5)downdistance
	nil  --(false)switchvalues
)
squapi.eye(
	models.model.root.Torso.head.Eyes.left, --element
	nil, --(.25)leftdistance
	nil, --(1.25)rightdistance
	nil, --(.5)updistance
	nil, --(.5)downdistance
	nil  --(false)switchvalues
)

function squapi.bouncetowards(current, target, vel, stiff, bounce)
	local bounce = bounce or 0.05
	local stiff = stiff or 0.005	
	local dif = target - current
	vel = vel + ((dif - vel * stiff) * stiff)
	current = (current + vel) + (dif * bounce)
	return current, vel
end


