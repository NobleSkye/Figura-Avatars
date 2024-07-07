-- Auto generated script file --

--hide vanilla armor model
vanilla_model.ARMOR:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.PLAYER:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)

--entity init event, used for when the avatar entity is loaded for the first time
function events.entity_init()
  --player functions goes here
end

--tick event, called 20 times per second
function events.tick()
  --code goes here
end

--render event, called every time your avatar is rendered
--it have two arguments, "delta" and "context"
--"delta" is the percentage between the last and the next tick (as a decimal value, 0.0 to 1.0)
--"context" is a string that tells from where this render event was called (the paperdoll, gui, player render, first person)
function events.render(delta, context)
  --code goes here
end


function pings.waveanim()
  animations.model.pose:play()
end
function events.chat_send_message(msg)
  if msg == "lamp" then
      pings.waveanim()
    end
  return msg
end

function pings.stopanim()
  animations.model.pose:stop()
end
function events.chat_send_message(msg)
  if msg == "cancel" then
      pings.waveanim()
    end
  return msg
end