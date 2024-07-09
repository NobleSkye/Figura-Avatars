-- Auto generated script file --


vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
local outline = require "outline"
outline(models.model,{color=vec(125,125,125)})


function pings.ohyaaa()
    sounds:playSound("ohyaaa", player:getPos())
  end
  function events.chat_send_message(msg)
    if msg == "ohyaaa" then
        pings.ohyaaa()
      end
    return msg
  end


