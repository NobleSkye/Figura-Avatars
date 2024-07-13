-- Define constants
local R = 10  -- Radius of the hypersphere
local num_points = 100  -- Number of points to generate


-- Assuming you have a reference to the particles module
local particles = particles  -- Replace with actual reference as per your environment

-- Function to spawn particles using Figura Lua
local function spawnParticles()
    for i = 0, num_points - 1 do
        local theta1 = math.acos(1 - 2 * (i / num_points))
        local theta2 = 2 * math.pi * ((1 + math.sqrt(5)) * i % 1)
        local theta3 = 2 * math.pi * ((1 + math.sqrt(7)) * i % 1)

        -- Calculate x, y, z coordinates
        local sin_theta1 = math.sqrt(1 - math.pow(1 - 2 * (i / num_points), 2))
        local x = R * sin_theta1 * math.cos(theta2)
        local y = R * sin_theta1 * math.sin(theta2)
        local z = R * (1 - 2 * (i / num_points))

        -- Print coordinates (optional)
        print(string.format("Particle %d: (%.2f, %.2f, %.2f)", i+1, x, y, z))

        -- Example: Spawn "crit" particles using Figura Lua particle API
        particles:newParticle("crit", {x, y, z})
    end
end

-- Example usage
spawnParticles()

page:newAction():title(""):item("").leftClick = function ()
    
end