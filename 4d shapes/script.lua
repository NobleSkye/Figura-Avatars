-- Define constants
local R = 10  -- Radius of the hypersphere
local num_points = 100  -- Number of points to generate
local coordinates = {}

-- Generate points on the hypersphere
for i = 0, num_points - 1 do
    local theta1 = math.acos(1 - 2 * (i / num_points))
    local theta2 = 2 * math.pi * ((1 + math.sqrt(5)) * i % 1)
    local theta3 = 2 * math.pi * ((1 + math.sqrt(7)) * i % 1)

    -- Calculate x, y, z coordinates
    local sin_theta1 = math.sqrt(1 - math.pow(1 - 2 * (i / num_points), 2))
    local x = R * sin_theta1 * math.cos(theta2)
    local y = R * sin_theta1 * math.sin(theta2)
    local z = R * (1 - 2 * (i / num_points))

    -- Insert coordinates into table
    table.insert(coordinates, {x, y, z})
end

-- Function to send summon commands
local function sendSummonCommands()
    for i, coord in ipairs(coordinates) do
        local x, y, z = coord[1], coord[2], coord[3]
        local summonCommand = string.format("summon armor_stand ~%.2f ~%.2f ~%.2f {Tags:['hypersphere_point'], Marker:1b, NoGravity:1b}", x, y, z)
        host:sendChatCommand(summonCommand)
    end
end

-- Function to send kill commands
local function sendKillCommands()
    host:sendChatCommand("kill @e[type=armor_stand,tag=hypersphere_point]")
end

-- Set up keybind to trigger summon commands
local summonKey = keybinds:newKeybind('Summon Hypersphere Points', 'key.keyboard.h')
summonKey.press = function()
    sendSummonCommands()
end

-- Set up keybind to trigger kill commands
local killKey = keybinds:newKeybind('Kill Hypersphere Points', 'key.keyboard.j')
killKey.press = function()
    sendKillCommands()
end

-- Function to rotate armor stands
local rotationAngle = 0
local function rotateArmorStands()
    rotationAngle = (rotationAngle + 1) % 360  -- Increment rotation angle (0 to 359 degrees)

    for i = 1, num_points do
        local rotationCommand = string.format("execute as @e[type=armor_stand,tag=hypersphere_point,limit=1,sort=nearest,distance=..0] at @s run tp @s ~ ~ ~ ~%d ~", rotationAngle)
        host:sendChatCommand(rotationCommand)
    end
end

-- Register tick event to rotate armor stands
function events.TICK()
    rotateArmorStands()
end
