local DEFAULT_ITEM = "leather_helmet"
local EQUIP_SOUND = "item.armor.equip_generic"
local EQUIP_PARTICLE = "spit"

local page = action_wheel:newPage()

---@type table<string, Accessory>
local accessories = {}

---@class Accessory
---@field name string
---@field parts table<string, ModelPart>
local Accessory = {}
Accessory.__index = Accessory

---@param name string
---@param item string|ItemStack
---@return Accessory
function Accessory.new(name, item)
    local self = setmetatable({}, Accessory)
    self.name = name
    self.item = item
    self.parts = {}
    return self
end

function Accessory:createAction()
    local action = page:newAction()
    action:item(self.item)
    action:title("Toggle " .. self.name)
    action:setToggled(self:getOverallVisibility() > 0.5)
    action:onToggle(function(val)
        pings.toggleAccessory(self.name, val)
    end)
    action:color(0.2,0.2,0.2)
end

---@return number visibility 0-1
function Accessory:getOverallVisibility()
    local visibility = 0
    for i = 1, #self.parts do
        visibility = visibility + (self.parts[i]:getVisible() and 1 or 0)
    end
    return visibility / #self.parts
end

---@param part ModelPart
function Accessory:addPart(part)
    self.parts[#self.parts+1] = part
end

---@param val boolean
function Accessory:toggle(val)
    for _, part in pairs(self.parts) do
        part:setVisible(val)
        for _ = 1, 5 do
            particles[EQUIP_PARTICLE]:pos(part:partToWorldMatrix():apply()):scale(0.5):gravity(0):lifetime(math.random(10,20)):spawn()
        end
    end
    sounds[EQUIP_SOUND]:pos(player:getPos()):volume(0.7):pitch(0.8):subtitle(self.name .. (val and " equipped" or " unequipped")):play()
end

---@param id string
---@param state boolean
function pings.toggleAccessory(id, state)
    if not player:isLoaded() then return end
    accessories[id]:toggle(state)
end

---@param item string
---@param fallback string
---@return string|ItemStack
local function validateItem(item, fallback)
    local valid_item, item = pcall(world.newItem, item)
    return valid_item and item or fallback
end

---@param part ModelPart
local function iterate(part)
    local part_name = part:getName()
    if part_name:find("^A/") then
        local name, item_id = part_name:match("^A/([^/]+)/?(.*)$")
        if not accessories[name] then
            local item = validateItem(item_id, DEFAULT_ITEM)
            accessories[name] = Accessory.new(name, item)
        end
        accessories[name]:addPart(part)
    end
    for _, child in pairs(part:getChildren()) do
        iterate(child)
    end
end

---@type { page: Page?, rightClick: ActionWheelAPI.clickFunc }
local old_wheel = {}
local function back()
    action_wheel:setPage(old_wheel.page)
    action_wheel.rightClick = old_wheel.right
end

page:newAction():title("§lBack§r"):item("arrow"):color(0.8,0.8,0.8):onLeftClick(back)

iterate(models)

local n_actions = 1
for _, accessory in pairs(accessories) do
    n_actions = n_actions + 1
    accessory:createAction()
end

while n_actions % 8 ~= 0 do
    n_actions = n_actions + 1
    page:newAction():hoverColor(0,0,0)
end

return action_wheel:newAction():title("Accessories"):item(DEFAULT_ITEM):onLeftClick(function ()
    old_wheel.page = action_wheel:getCurrentPage()
    old_wheel.right = action_wheel.rightClick
    action_wheel.rightClick = back
    action_wheel:setPage(page)
end)