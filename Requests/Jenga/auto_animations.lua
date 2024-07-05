---@param model string
---@param id string
---@param state? boolean
function pings.animation(model, id, state)
    if state ~= nil then
        animations[model][id]:setPlaying(state)
    else
        animations[model][id]:play()
    end
end

if not host:isHost() then return action_wheel:newAction() end

local page = action_wheel:newPage()

---@type { page: Page?, rightClick: ActionWheelAPI.clickFunc }
local old_wheel = {}
local function back()
    action_wheel:setPage(old_wheel.page)
    action_wheel.rightClick = old_wheel.right
end

page:newAction():title("§lBack§r"):item("arrow"):color(0.8,0.8,0.8):onLeftClick(back)

local n_actions = 1
for _, data in pairs(avatar:getNBT().animations or {}) do
    local action_type, title, item_name = data.name:match('([^/]+)/([^/]+)/([^/]+)')
    if action_type and title then
        n_actions = n_actions + 1
        local valid_item, item = pcall(world.newItem, item_name)
        local action = page:newAction():title(title):item(valid_item and item or "stone")
        action:color(0.2,0.2,0.2)
        if action_type == "action" then
            action:onLeftClick(function() pings.animation(data.mdl, data.name) end)
        elseif action_type == "toggle" then
            action:onToggle(function(state) pings.animation(data.mdl, data.name, state) end)
        end
    end
end

while n_actions % 8 ~= 0 do
    n_actions = n_actions + 1
    page:newAction():hoverColor(0,0,0)
end

return action_wheel:newAction():title("Animations"):item("armor_stand"):onLeftClick(function ()
    old_wheel.page = action_wheel:getCurrentPage()
    old_wheel.right = action_wheel.rightClick
    action_wheel.rightClick = back
    action_wheel:setPage(page)
end)