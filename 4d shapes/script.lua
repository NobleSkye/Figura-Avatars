local R = 10  -- Radius of the sphere
local num_points = 100  -- Number of points to generate

-- List to store coordinates
local coordinates = {}

-- Generate points on the sphere
for i = 0, num_points - 1 do
    local theta = math.acos(1 - 2 * (i / num_points))  -- Polar angle
    local phi = 2 * math.pi * ((1 + math.sqrt(5)) * i % 1)  -- Azimuthal angle

    local x = R * math.sin(theta) * math.cos(phi)
    local y = R * math.sin(theta) * math.sin(phi)
    local z = R * math.cos(theta)

    table.insert(coordinates, {x, y, z})
end

-- Function to summon armor stands and generate particles
local function summonArmorStandsAndParticles()
    for _, coord in ipairs(coordinates) do
        local x, y, z = coord[1], coord[2], coord[3]

        -- Summon armor stand using the correct command method
        commands.execAsync(string.format("summon minecraft:armor_stand %f %f %f {Tags:['sphere_point'], Marker:1b, NoGravity:1b}", x, y, z))

        -- Generate particles at the armor stand location
        for i = 1, 10 do
            particles:newParticle("minecraft:happy_villager", x, y, z, 0, 0, 0)
        end
    end
end

-- Bind the function to a key for testing purposes
local key = keybinds:newKeybind("Summon Sphere Points", "key.keyboard.h")
key.press = summonArmorStandsAndParticles
