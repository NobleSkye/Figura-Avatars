-- Auto generated script file --

--hide vanilla model
vanilla_model.PLAYER:setVisible(false)

vanilla_model.CAPE:setVisible(false)

local mainPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

mainPage:setAction(-1, require("auto_accessories"))
mainPage:setAction(-1, require("auto_animations"))