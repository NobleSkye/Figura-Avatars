-- Define constants
local R = 10  -- Radius of the hypersphere
local max_points = 25  -- Limit number of points to 25
local coordinates = {}
local rotate = false
local particles = false

-- Generate points on the hypersphere
for i = 0, max_points - 1 do
    local theta1 = math.acos(1 - 2 * (i / max_points))
    local theta2 = 2 * math.pi * ((1 + math.sqrt(5)) * i % 1)

    -- Calculate x, y, z coordinates
    local sin_theta1 = math.sqrt(1 - math.pow(1 - 2 * (i / max_points), 2))
    local x = R * sin_theta1 * math.cos(theta2)
    local y = R * sin_theta1 * math.sin(theta2)
    local z = R * (1 - 2 * (i / max_points))

    -- Insert coordinates into table
    table.insert(coordinates, {x, y, z})
end

-- Function to send summon commands
local function sendSummonCommands()
    for i, coord in ipairs(coordinates) do
        local x, y, z = coord[1], coord[2], coord[3]
        local summonCommand = string.format("summon marker ~%.2f ~%.2f ~%.2f {Tags:['hypersphere_point'], Marker:1b, NoGravity:1b}", x, y, z)
        host:sendChatCommand(summonCommand)
    end
end

-- Function to send kill commands
local function sendKillCommands()
    host:sendChatCommand("kill @e[type=marker,tag=hypersphere_point]")
end

-- Function to send particle commands
local function sendParticleCommands()
    local particleCommand = "/execute at @e[type=minecraft:marker,tag=hypersphere_point] run particle minecraft:crit ~ ~ ~ 0.5 0.5 0.5 0.02 10 force"
    host:sendChatCommand(particleCommand)
end

-- Set up keybind to trigger summon commands
local summonKey = keybinds:newKeybind('Summon Hypersphere Points', 'key.keyboard.h')
summonKey.press = function()
    print("Summon Hypersphere Points: true")
    sendSummonCommands()
end

-- Set up keybind to trigger kill commands
local killKey = keybinds:newKeybind('Kill Hypersphere Points', 'key.keyboard.j')
killKey.press = function()
    print("Kill Hypersphere Points: true")
    sendKillCommands()
end

-- Set up keybind to toggle rotation
local toggleRotationKey = keybinds:newKeybind('Toggle Rotation', 'key.keyboard.l')
toggleRotationKey.press = function()
    rotate = not rotate
    print("Toggle Rotation: " .. tostring(rotate))
end

-- Set up keybind to toggle particle effects
local toggleParticleKey = keybinds:newKeybind('Toggle Particles', 'key.keyboard.i')
toggleParticleKey.press = function()
    particles = not particles
    print("Toggle Particles: " .. tostring(particles))
end

-- Function to rotate armor stands around the player
local rotationAngle = 0
local function rotateArmorStands()
    rotationAngle = (rotationAngle + 1) % 360  -- Increment rotation angle (0 to 359 degrees)

    for i, coord in ipairs(coordinates) do
        local theta = 2 * math.pi * (i / max_points) + math.rad(rotationAngle)
        local x = R * math.cos(theta)
        local z = R * math.sin(theta)

        local rotationCommand = string.format("tp @s ^%.2f ^ ^%.2f", x, z)
        host:sendChatCommand(string.format("execute as @e[type=marker,tag=hypersphere_point,limit=5,sort=nearest] at @p run %s", rotationCommand))
    end
end

-- Register tick event to rotate armor stands and send particle commands
function events.TICK()
    if rotate then
        rotateArmorStands()
    end
    if particles then
        sendParticleCommands()
    end
end
