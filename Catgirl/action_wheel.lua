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




local mainPage = action_wheel:newPage()

action_wheel:setPage(mainPage)



-- Libary Calls
mainPage:setAction(-1, require("auto_animations"))
mainPage:setAction(-1, require("auto_accessories"))


-- UwUify Chat Script by Smoliv


local uwo = false
function pings.owu(state)
if state then
  uwo = true
  models.model:setVisible(false)
  models.uwu:setVisible(true)
  nameplate.ALL:setText("§dUwU Skye :uwu:")
else
  uwo = false
  models.model:setVisible(true)
  models.uwu:setVisible(false)
  nameplate.LIST:setText("§d Skye :trans:")
  nameplate.ENTITY:setText("§d Skye")
  nameplate.CHAT:setText("§d Skye")
end

end
local action = mainPage:newAction()
:title("uwu")
:item("minecraft:cat_spawn_egg")
:hoverColor(1,0,1)
:setOnToggle(pings.owu)


function uwuify(text)
    text = text:gsub("[LR]", "W")
    text = text:gsub("[lr]", "w")
    text = text:gsub("[a]", "awa")
    text = text:gsub("[A]", "Awa")
    text = text:gsub("[e]", "ewe")
    text = text:gsub("[E]", "EwE")
    text = text:gsub("[i]", "iwi")
    text = text:gsub("[I]", "IwI")
    text = text:gsub("[o]", "owo")    
    text = text:gsub("[O]", "OwO")
    text = text:gsub("[u]", "uwu")
    text = text:gsub("[U]", "UwU")
    return text
end
-- Main function to modify the chat message based on intoxication level
function events.chat_send_message(msg)
    if msg:find("/") then return msg end
  if uwo then
    msg = uwuify(msg)
  end
    return msg
  end



