local squapi = require("SquAPI")

JukeboxAPI = require "JukeboxAPI"

--replace each nil with the value/parmater you want to use, or leave as nil to use default values :)
--parenthesis are default values for reference
squapi.bounceWalk:new(
    models.model,    --model
    nil     --(1) bounceMultiplier
)
--replace each nil with the value/parmater you want to use, or leave as nil to use default values :)
--parenthesis are default values for reference
squapi.smoothHead:new(
    {
        models.model.root.Head --element(you can have multiple elements in a table)
    },
    nil,    --(1) strength(you can make this a table too)
    nil,    --(0.1) tilt
    nil,    --(1) speed
    nil     --(true) keepOriginalHeadPos
)
--replace each nil with the value/parmater you want to use, or leave as nil to use default values :)
--parenthesis are default values for reference
squapi.eye:new(
    models.model.root.Head.eyes,  --the eye element 
    nil,  --(0.25) left distance
    0.25,  --(1.25) right distance
    nil,  --(0.5) up distance
    nil   --(0.5) down distance
)
local skirtPhysics = require("skirt_physics")

--hide vanilla model
vanilla_model.PLAYER:setVisible(false)

--hide vanilla armor model
vanilla_model.ARMOR:setVisible(false)

--call skirtPhysics function
skirtPhysics.new(models.model.root.Body.Skirt)

-- Create pages

local home_page = action_wheel:newPage('home')
local sounds_page = action_wheel:newPage('sounds')

-- Setup configuration of the API

JukeboxAPI.config
    :setTargetPage(sounds_page)
    :setActionColor('#442511')
    :setActionZebraStripping(true)
action_wheel:setPage(sounds_page)

-- Register additional sounds

-- Single:
JukeboxAPI:registerAvatarSound('minecraft:pink_dye', 'wonderhoy', 'Wonderhoy', 'PJSK')