local skirtPhysics = require("skirt_physics")

models.stagearima.root:setVisible(false)

--hide vanilla model
vanilla_model.PLAYER:setVisible(false)

--hide vanilla armor model
vanilla_model.ARMOR:setVisible(false)

--call skirtPhysics function
skirtPhysics.new(models.model.root.Body.Skirt)
skirtPhysics.new(models.stagearima.root.Body.Skirt)

--models.model.root.LeftLeg:setParentType("none"):setRot(60,0,0)

local mainPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

function pings.hidea(state)
	config:save("armour", state)
	armourShow = not state
	vanilla_model.ARMOR:setVisible(not state)
end

local mainPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

function pings.toggling(a)
    models.model.root:setVisible(a)
    models.stagearima.root:setVisible(not a)
end

local toggleaction = mainPage:newAction()
    :title("Switch to school outfit")
    :toggleTitle("Switch to stage outfit")
    :item("red_wool")
    :toggleItem("green_wool")
    :setOnToggle(pings.toggling)