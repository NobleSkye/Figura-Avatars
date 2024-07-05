      ___           ___                         ___           ___                    ___           ___           ___                                              
     /  /\         /  /\          __           /  /\         /  /\                  /  /\         /  /\         /  /\           ___         ___           ___     
    /  /::\       /  /:/         |  |\        /  /::\       /  /::\                /  /::\       /  /::\       /  /::\         /__/\       /  /\         /__/\    
   /__/:/\:\     /  /:/          |  |:|      /  /:/\:\     /__/:/\:\              /__/:/\:\     /  /:/\:\     /  /:/\:\        \__\:\     /  /::\        \  \:\   
  _\_ \:\ \:\   /  /::\____      |  |:|     /  /::\ \:\   _\_ \:\ \:\            _\_ \:\ \:\   /  /:/  \:\   /  /::\ \:\       /  /::\   /  /:/\:\        \__\:\  
 /__/\ \:\ \:\ /__/:/\:::::\     |__|:|__  /__/:/\:\ \:\ /__/\ \:\ \:\          /__/\ \:\ \:\ /__/:/ \  \:\ /__/:/\:\_\:\   __/  /:/\/  /  /::\ \:\       /  /::\ 
 \  \:\ \:\_\/ \__\/~|:|~~~~     /  /::::\ \  \:\ \:\_\/ \  \:\ \:\_\/          \  \:\ \:\_\/ \  \:\  \__\/ \__\/~|::\/:/  /__/\/:/~~  /__/:/\:\_\:\     /  /:/\:\
  \  \:\_\:\      |  |:|        /  /:/~~~~  \  \:\ \:\    \  \:\_\:\             \  \:\_\:\    \  \:\          |  |:|::/   \  \::/     \__\/  \:\/:/    /  /:/__\/
   \  \:\/:/      |  |:|       /__/:/        \  \:\_\/     \  \:\/:/              \  \:\/:/     \  \:\         |  |:|\/     \  \:\          \  \::/    /__/:/     
    \  \::/       |__|:|       \__\/          \  \:\        \  \::/                \  \::/       \  \:\        |__|:|~       \__\/           \__\/     \__\/      
     \__\/         \__\|                       \__\/         \__\/                  \__\/         \__\/         \__\|                                             



local musicPage = action_wheel:newPage()
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





-- changes what page your on
mainPage:newAction()
:setTitle('Music Player')
:item('minecraft:music_disc_mellohi')
:setOnLeftClick(
    function()
        action_wheel:setPage(musicPage)
    end)
    
musicPage:newAction()
:setTitle('Home')
:item('minecraft:magenta_glazed_terracotta')
:setOnLeftClick(
    function()
        action_wheel:setPage(mainPage)
    end
)





musicPage:newAction()
:setTitle('Clear Disc')
:item('minecraft:barrier')
:setOnLeftClick(
    function()
        host:sendChatCommand("/audioplayer clear")
        log("Disc Cleared ")
    end
)

-- Music Discs

musicPage:newAction()
:setTitle('Pigstep remix')
:item('minecraft:jukebox')
:setOnLeftClick(
    function()
        
        host:sendChatCommand("/audioplayer apply 952c790f-236a-44e6-ae99-e78d1c7fd962 'Pigstep remix'")
        log("Disc set Pigstep remix")
    end
)


musicPage:newAction()
:setTitle('Screw the Nether')
:item('minecraft:jukebox')
:setOnLeftClick(
    function()
        
        host:sendChatCommand("/audioplayer apply 2a1e709d-fcbf-437b-ba43-d2efb0550959 'Screw the Nether'")
        log("Disc set Screw the Nether")
    end
)
musicPage:newAction()
:setTitle('How Do i Craft This Again?')
:item('minecraft:jukebox')
:setOnLeftClick(
    function()
        
        host:sendChatCommand("/audioplayer apply 70a185f1-718b-4d9f-be7c-d8fd54a7e37b 'How Do i Craft This Again?'")
        log("Disc set How Do i Craft This Again?")
    end
)
musicPage:newAction()
:setTitle('We\'re The Piglin')
:item('minecraft:jukebox')
:setOnLeftClick(
    function()
        
        host:sendChatCommand("/audioplayer apply 8f686649-5fa1-496c-9af5-9ca75b986a1e 'We`re The Piglin'")
        log("Disc set We're The Piglin")
    end
)
musicPage:newAction()
:setTitle('Level Up | AntVenom')
:item('minecraft:jukebox')
:setOnLeftClick(
    function()
        
        host:sendChatCommand("/audioplayer apply 4b4c4a70-2245-4530-8ce6-dbd391e120ec 'Level Up | AntVenom'")
        log("Disc set Level Up | AntVenom")
    end
)
musicPage:newAction()
:setTitle('Empire')
:item('minecraft:jukebox')
:setOnLeftClick(
    function()
        
        host:sendChatCommand("/audioplayer apply 1a9f1961-bd2d-4050-a950-e1fbbf962030 'Empire'")
        log("Disc set Empire")
    end
)
musicPage:newAction()
:setTitle('Breeze')
:item('minecraft:jukebox')
:setOnLeftClick(
    function()
        
        host:sendChatCommand("/audioplayer apply 51658197-c82c-48a2-a2c7-03951cf5aa02 'Breeze'")
        log("Disc set Breeze")
    end
)
musicPage:newAction()
:setTitle('Otherside Remix')
:item('minecraft:jukebox')
:setOnLeftClick(
    function()
        
        host:sendChatCommand("/audioplayer apply 82d27543-616b-436b-95f4-1fa8ba69077e 'Otherside Remix'")
        log("Disc set Otherside Remix")
    end
)
musicPage:newAction()
:setTitle('OtherStep')
:item('minecraft:jukebox')
:setOnLeftClick(
    function()
        
        host:sendChatCommand("/audioplayer apply 17ea95c2-cf6b-48b2-835c-a928aff98a95 'OtherStep'")
        log("Disc set OtherStep")
    end
)
musicPage:newAction()
:setTitle('No Escape @T_en_M')
:item('minecraft:jukebox')
:setOnLeftClick(
    function()
        
        host:sendChatCommand("/audioplayer apply f4b4e051-915a-4bef-8173-e0127aa0d084 'No Escape @T_en_M'")
        log("Disc set No Escape @T_en_M")
    end
)
musicPage:newAction()
:setTitle('Want You Gone')
:item('minecraft:jukebox')
:setOnLeftClick(
    function()
        
        host:sendChatCommand("/audioplayer apply 5d860eb8-afe5-482d-b947-eb5fe5161eb7 'Want You Gone'")
        log("Disc set Want You Gone")
    end
)
musicPage:newAction()
:setTitle('Don\'t Mine at Night')
:item('minecraft:jukebox')
:setOnLeftClick(
    function()
        
        host:sendChatCommand("/audioplayer apply 62156547-c8ad-4607-9fdc-49c99812dfd9 'Don`t Mine at Night'")
        log("Disc set Don't Mine at Night")
    end
)
musicPage:newAction()
:setTitle('I\'ve Got A Bone | Dan Bull')
:item('minecraft:jukebox')
:setOnLeftClick(
    function()
        
        host:sendChatCommand("/audioplayer apply 5bf64b7c-67bf-4846-a098-b1e41e2adb5f 'I`ve Got A Bone | Dan Bull'")
        log("Disc set I've Got A Bone | Dan Bull")
    end
)
musicPage:newAction()
:setTitle('CREEPER RAP | Dan Bull')
:item('minecraft:jukebox')
:setOnLeftClick(
    function()
        
        host:sendChatCommand("/audioplayer apply a1555f01-cfb5-49cf-890b-b79c7763af4d 'CREEPER RAP | Dan Bull'")
        log("Disc set CREEPER RAP | Dan Bull")
    end
)


-- AD Sounds

musicPage:newAction()
:setTitle('Want A Break From The ADs?')
:item('minecraft:jukebox')
:setOnLeftClick(
    function()
        
        host:sendChatCommand("/audioplayer apply 8d8e1e55-b8da-46fc-b9f0-ec2264dad71a 'Want A Break From The ADs?'")
        log("Disc set Want A Break From The ADs?")
    end
)


musicPage:newAction()
:setTitle('SHOPIFY AD')
:item('minecraft:jukebox')
:setOnLeftClick(
    function()
        
        host:sendChatCommand("/audioplayer apply 677226ef-b090-4f02-8e28-a2aa219b2ac1 'SHOPIFY AD'")
        log("Disc set SHOPIFY AD")
    end
)

musicPage:newAction()
:setTitle('Honey AD')
:item('minecraft:jukebox')
:setOnLeftClick(
    function()
        
        host:sendChatCommand("/audioplayer apply fde6e60f-0b07-4b48-b96e-53743f6c39fe 'Honey AD'")
        log("Disc set Honey AD")
    end
)
musicPage:newAction()
:setTitle('Minecraft Poem')
:item('minecraft:jukebox')
:setOnLeftClick(
    function()
        
        host:sendChatCommand("/audioplayer apply 6d45e3bc-2c00-4f67-a066-de11f5a1f040 'Minecraft Poem'")
        log("Disc set Minecraft Poem")
    end
)
