-- Auto generated script file --
vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)

local SwingingPhysics = require("swinging_physics")
local swingOnHead = SwingingPhysics.swingOnHead
local swingOnBody = SwingingPhysics.swingOnBody

swingOnHead(models.model.HuTao.Head.hair, 90, {-90,0,-90,90,-90,90})
swingOnHead(models.model.HuTao.Head.hair2, 90, {-90,0,-90,90,-90,90})

swingOnBody(models.model.HuTao.Body.skirt, 90, {-90,0,-90,90,-90,90})
swingOnBody(models.model.HuTao.Body.skirt2, 90, {-90,0,-90,90,-90,90})

local squapi = require("SquAPI")

squapi.eye(models.model.HuTao.Head.Eyes.lefteye)
squapi.eye(models.model.HuTao.Head.Eyes.righteye)
squapi.blink(animations.model.blink)


function events.entity_init()
	require("physBoneAPI")
	physBone.physBoobas:setGravity(1)
	physBone.physBoobas:setAirResistance(0)
	physBone.physBoobas:setSpringForce(100)
end