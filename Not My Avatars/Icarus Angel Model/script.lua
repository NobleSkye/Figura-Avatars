-- Auto generated script file --

--hide vanilla model
vanilla_model.PLAYER:setVisible(false)

--hide vanilla armor model
vanilla_model.ARMOR:setVisible(false)

--hide vanilla cape model
vanilla_model.CAPE:setVisible(false)

--hide vanilla elytra model
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




--Render Textures
models.AthenaAngel.main.mainbody.head.halo:setPrimaryRenderType("EMISSIVE_SOLID")
models.AthenaAngel.main.mainbody.head.halo:setSecondaryRenderType("GLINT")
models.AthenaAngel.main.mainbody.head.crown:setSecondaryRenderType("GLINT")

--GlintOption (Only did it for one wing as a test)
--models.AthenaAngel.main.mainbody.Body.Leftmainwing.eye1.iris:setPrimaryRenderType("EMISSIVE_SOLID")
--models.AthenaAngel.main.mainbody.Body.Leftmainwing.leftsegment2.eye2.iris2:setPrimaryRenderType("EMISSIVE_SOLID")
--models.AthenaAngel.main.mainbody.Body.Leftmainwing.leftsegment2.leftsegment3.eye3.iris3:setPrimaryRenderType("EMISSIVE_SOLID")
--models.AthenaAngel.main.mainbody.Body.Leftmainwing.eye1.iris:setSecondaryRenderType("GLINT")
--models.AthenaAngel.main.mainbody.Body.Leftmainwing.leftsegment2.eye2.iris2:setSecondaryRenderType("GLINT")
--models.AthenaAngel.main.mainbody.Body.Leftmainwing.leftsegment2.leftsegment3.eye3.iris3:setSecondaryRenderType("GLINT")


--Squapi
local squapi = require("SquAPI")

squapi.smoothTorso(models.AthenaAngel.main.mainbody, 0.3)
squapi.smoothHead(models.AthenaAngel.main.mainbody.head, 0.3)
squapi.eye(models.AthenaAngel.main.mainbody.head.Eyes.eye, 0.3, 0.3)
squapi.eye(models.AthenaAngel.main.mainbody.head.Eyes.eyee, 0.3, 0.3)
squapi.blink(animations.AthenaAngel.blink)

--anim Requires
require("GSAnimBlend")
local anims = require("JimmyAnims")
anims(animations.AthenaAngel)


--Animations
animations.AthenaAngel.idle:play()
animations.AthenaAngel.idle:play()
animations.AthenaAngel.idle:setBlendTime(10)
animations.AthenaAngel.fly:setBlendTime(10)
animations.AthenaAngel.flywalk:setBlendTime(10)
animations.AthenaAngel.flywalkback:setBlendTime(10)



--Toggle
local mainPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

-- assignment
local action1 = mainPage:newAction()
action1:title("Halo")
action1:item("glowstone_dust")
action1:hoverColor(1,0,1)
function pings.haloVisible(toggled)
    models.AthenaAngel.main.mainbody.head.halo:setVisible(toggled)
	end
action1.toggle = pings.haloVisible 
function events.tick()
  if world:getTime() % 20 == 0 then
    pings.haloVisible(action1:isToggled())
  end
end


local action2 = mainPage:newAction()
action2:title("Mask")
action2:item("minecraft:netherite_helmet")
action2:hoverColor(1,0,1)
function pings.maskVisible(toggled)
    models.AthenaAngel.main.mainbody.head.mask:setVisible(toggled)
	end
action2.toggle = pings.maskVisible 
function events.tick()
  if world:getTime() % 20 == 0 then
    pings.maskVisible(action2:isToggled())
  end
end



local action3 = mainPage:newAction()
action3:title("Eyes")
action3:item("ender_eye")
action3:hoverColor(1,0,1)
eyes_toggled = true
function pings.eyeVisible(v)
    eyes_toggled = v
end
action3.toggle = pings.eyeVisible 
function events.tick()
  if world:getTime() % 20 == 0 then
    pings.eyeVisible(eyes_toggled)
  end
end




local oldhealth = 0
function events.entity_init()
	local health = player:getHealth()
	oldhealth = health
end

events.TICK:register(function()
	local health = player:getHealth()

	--Ambience and Damage Sounds
	if math.random(0,10000) > 9999 then
		sounds:playSound("ambient.soul_sand_valley.mood", player:getPos())
	end
	if math.random(0,10000) > 9999 then
		sounds:playSound("entity.dolphin.play", player:getPos())
	end
	if oldhealth > health then
		sounds:playSound("item.trident.return", player:getPos(), 1, 1)
	end

	--Eyes visible at less than 4 hearts
	local eyes = health <= 8

	models.AthenaAngel.main.mainbody.Body.Leftmainwing.eye1:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.Leftmainwing.leftsegment2.eye2:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.Leftmainwing.leftsegment2.leftsegment3.eye3:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.Rightmainwing.eye4:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.Rightmainwing.rightsegment2.eye5:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.Rightmainwing.rightsegment2.rightsegment3.eye6:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.Rightminwing.eye10:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.Rightminwing.rightminisegment2.eye11:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.Rightminwing.rightminisegment2.rightminisegment3.eye12:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.Leftminwing.eye7:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.Leftminwing.leftminisegment2.eye8:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.Leftminwing.leftminisegment2.leftminisegment3.eye9:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.Rightminwing.rightminisegment2.rightminisegment3.eye12:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.Leftminwing.eye7:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.Leftminwing.leftminisegment2.eye8:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.Leftminwing.leftminisegment2.leftminisegment3.eye9:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.RightMiniestwing.eye13:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.RightMiniestwing.rightminisegment4.eye14:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.RightMiniestwing.rightminisegment4.rightminisegment5.eye15:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.LeftMiniestwing.eye16:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.LeftMiniestwing.leftminisegment4.eye17:setVisible(eyes or eyes_toggled)
	models.AthenaAngel.main.mainbody.Body.LeftMiniestwing.leftminisegment4.leftminisegment5.eye18:setVisible(eyes or eyes_toggled)

	-- Sound when reaching 4 hearts (8 health)
	if health <= 8 and oldhealth > 8 then
		sounds:playSound("entity.elder_guardian.curse", player:getPos(), 1, 1)
		animations.AthenaAngel.pain:play()
	end

	oldhealth = health
end)

--	sounds:playSound("entity.elder_guardian.curse",player:getPos(),1,1)
--	animations.AthenaAngel.pain:play()