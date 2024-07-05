local WALK_ANIMATION = animations.Crab.walkin
local FALL_ANIMATION = animations.Crab.fall
local HIDE_ANIMATION = animations.Crab.hide
local UNHIDE_ANIMATION = animations.Crab.unhide

local ENABLED_COLOR = vectors.hexToRGB("#a6e3a1")
local DISABLED_COLOR = vectors.hexToRGB("#f38ba8")

local hideEnabled

local hideToggleAction

-----------
-- Pings --
-----------

function pings.sync(hideState)
	hideEnabled = hideState
end

local function quickSync()
	pings.sync(hideEnabled)
end

------------------
-- Action Wheel --
------------------

local function printState(string, state)
    local function fancyState(value)
        if value == true or value == false then
            if value then return "§aEnabled" else return "§cDisabled" end
        else
            return "§b" .. value
        end
    end
    print(string .. ": " .. (fancyState(state)))
end

local function toggleHide(state)
	printState("Hidden", state)
	hideEnabled = state
	hideToggleAction:setToggled(hideEnabled)
	quickSync()
end

----------------
-- Visibility --
----------------

local function setBodyVisibility(state)
	models.Crab.MIMIC_TORSO.INNER:setVisible(state)
	models.Crab.HEAD:setVisible(state)
	models.Crab.RIGHT_ARM:setVisible(state)
	models.Crab.LEFT_ARM:setVisible(state)
	models.Crab.LEFT_CRAWLERS:setVisible(state)
	models.Crab.RIGHT_CRAWLERS:setVisible(state)
end

----------------------
-- Figura Functions --
----------------------

function events.entity_init()

	vanilla_model.PLAYER:setVisible(false)
	vanilla_model.ARMOR:setVisible(false)
	vanilla_model.ELYTRA:setVisible(false)

	nameplate.ENTITY:setPivot(0, 1, 0)

	local emotePage = action_wheel:newPage("Emotes")
	action_wheel:setPage(emotePage)

	hideToggleAction = emotePage:newAction()
		:item("minecraft:nautilus_shell")
		:title("Hide")
		:color(DISABLED_COLOR)
		:onToggle(toggleHide)
		:toggleTitle("Stop Hiding")
		:toggleColor(ENABLED_COLOR)
    hideToggleAction:setToggled(hideEnabled)
end

function events.tick()
	if player:getPose() == "STANDING" then
		if WALK_ANIMATION:getPlayState() ~= "PLAYING" then
			WALK_ANIMATION:play()
		end

		-- stop leg pedalling when jumping
		if player:getVelocity().y ~= 0 then
			WALK_ANIMATION:setSpeed(1)
		else
			WALK_ANIMATION:setSpeed(player:getVelocity():length() * 10)
		end	
	else
		if WALK_ANIMATION:getPlayState() ~= "STOPPED" then
			WALK_ANIMATION:stop()
		end
	end

	if player:getVelocity().y <= 0 then
		FALL_ANIMATION:stop()
	else
		FALL_ANIMATION:play()
	end

	if player:getVelocity():length() >= 0.1 and hideEnabled then
		toggleHide(false)
	end
end

function events.render(delta, context)
	if context == "FIRST_PERSON" then
		models:setVisible(false)
	else
		models:setVisible(true)
	end

	local headBodyOffset = (player:getRot().y - player:getBodyYaw() + 180) % 360 - 180

	local headRot = vec(player:getRot().x, headBodyOffset)

	if headRot.x < 0 then
		models.Crab.HEAD.BASE.EYES:setRot(-headRot.x/3, -headRot.y * 0.75, 0)
	else
		models.Crab.HEAD.BASE.EYES:setRot(headRot.x/2, -headRot.y * 0.75, 0)
	end

	if headRot.x < 0 then
		models.Crab.HEAD.BASE:setRot(headRot.x, 0, 0)
	end

	if hideEnabled then
		if HIDE_ANIMATION:getPlayState() == "STOPPED" then
			HIDE_ANIMATION:setSpeed(1)
			HIDE_ANIMATION:loop("HOLD")
			HIDE_ANIMATION:play()
			UNHIDE_ANIMATION:stop()
		end
	else
		if math.abs(HIDE_ANIMATION:getTime()) >= HIDE_ANIMATION:getLength() then
			HIDE_ANIMATION:stop()
			UNHIDE_ANIMATION:play()
		end
	end

	if math.abs(HIDE_ANIMATION:getTime()) >= HIDE_ANIMATION:getLength() and hideEnabled then
		setBodyVisibility(false)
	else
		setBodyVisibility(true)
	end

	if HIDE_ANIMATION:getPlayState() == "PLAYING" then
		vanilla_model.HELD_ITEMS:setVisible(false)
	else
		vanilla_model.HELD_ITEMS:setVisible(true)
	end

end