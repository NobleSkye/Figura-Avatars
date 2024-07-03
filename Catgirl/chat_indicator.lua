--custom height modifier in blockbench units. can be positive or negative
local custom_height = 0

-- you will need to change this if it's in a subfolder
-- e.g. if it's in a subfolder named "abcdef" it's models.abcdef.holder
local holder = models.holder

-- don't need to edit anything below this line

assert(
	holder,"§9§lChat Indicator§f: The chat bubble's container model wasn't found. You most likely put it in a subfolder and haven't edited the model path appropriately. Look in §achat_indicator.lua§f for instructions."
)

local bubble_holder = holder.bone
local chatbubble = bubble_holder:newSprite("chatbubble")
chatbubble:setTexture(bubble_holder.cube:getTextures()[1], 12, 13)
chatbubble:setDimensions(120, 13)

events.TICK:register(function()
	chatbubble_height = (player:getBoundingBox().y * (16 * math.playerScale)) + (5 * player:getBoundingBox().y) + custom_height
	holder:setPos(vec(0,chatbubble_height,0))
	chatbubble:setPos(2.5,13,0)
end)

bubble_holder:setParentType("Camera")

chatstate = true
lastchatstate = false

function pings.chatBubbleToggle(v)
	chatbubble:setVisible(v)
end

events.TICK:register(function()
	lastchatstate = chatstate
	chatstate = host:isChatOpen() and player:getPose() ~= "SLEEPING" and player:isSneaking() == false
	if chatstate ~= lastchatstate then
		pings.chatBubbleToggle(chatstate)
	end
	chatbubble:setUVPixels((math.floor(world.getTime()/8) % 10)*12, 0)
end)

bubble_holder.cube:remove()
