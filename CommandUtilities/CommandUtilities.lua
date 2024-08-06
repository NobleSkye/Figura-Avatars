--       ___           ___           ___           ___           ___           ___           ___          
--      /  /\         /  /\         /  /\         /  /\         /  /\         /  /\         /  /\         
--     /  /::\       /  /::\       /  /::|       /  /::|       /  /::\       /  /::|       /  /::\        
--    /  /:/\:\     /  /:/\:\     /  /:|:|      /  /:|:|      /  /:/\:\     /  /:|:|      /  /:/\:\       
--   /  /:/  \:\   /  /:/  \:\   /  /:/|:|__   /  /:/|:|__   /  /::\ \:\   /  /:/|:|__   /  /:/  \:\      
--  /__/:/ \  \:\ /__/:/ \__\:\ /__/:/_|::::\ /__/:/_|::::\ /__/:/\:\_\:\ /__/:/ |:| /\ /__/:/ \__\:|     
--  \  \:\  \__\/ \  \:\ /  /:/ \__\/  /~~/:/ \__\/  /~~/:/ \__\/  \:\/:/ \__\/  |:|/:/ \  \:\ /  /:/     
--   \  \:\        \  \:\  /:/        /  /:/        /  /:/       \__\::/      |  |:/:/   \  \:\  /:/      
--    \  \:\        \  \:\/:/        /  /:/        /  /:/        /  /:/       |__|::/     \  \:\/:/       
--     \  \:\        \  \::/        /__/:/        /__/:/        /__/:/        /__/:/       \__\__/        
--      \__\/         \__\/         \__\/         \__\/         \__\/         \__\/                       


-- Variable to keep track of invisibility status
local is_invisible = false

-- Function to set game mode to survival
function gms()
    host:sendChatCommand("/gamemode survival")
end

-- Function to set game mode to creative
function gmc()
    host:sendChatCommand("/gamemode creative")
end

-- Function to set game mode to spectator
function gmsp()
    host:sendChatCommand("/gamemode spectator")
end

-- Function to set game mode to adventure
function gma()
    host:sendChatCommand("/gamemode adventure")
end

-- Function to change player scale
function plscale_change(scale)
    if scale then
        host:sendChatCommand("/attribute @s minecraft:generic.scale base set " .. scale)
    else
        print("Error: Scale parameter is nil")
    end
end

-- Function to reset player scale
function reset_plscale()
    host:sendChatCommand("/attribute @s minecraft:generic.scale base set 1")
end

-- Function to change player speed
function plspeed_change(speed)
    if speed then
        host:sendChatCommand("/attribute @s minecraft:generic.movement_speed base set " .. speed)
    else
        print("Error: Speed parameter is nil")
    end
end

-- Function to reset player speed
function reset_plspeed()
    host:sendChatCommand("/attribute @s minecraft:generic.movement_speed base set 0.1")  -- Default speed (adjust as needed)
end

-- Function to reset all attributes
function reset_all_attributes()
    reset_plscale()
    reset_plspeed()
    reset_reach()  -- Reset reach as well
end

-- Function to change player reach distance
function reach_change(reach)
    if reach then
        host:sendChatCommand("/attribute @s minecraft:player.block_interaction_range base set " .. reach)
    else
        print("Error: Reach parameter is nil")
    end
end

-- Function to reset player reach distance
function reset_reach()
    host:sendChatCommand("/attribute @s minecraft:player.block_interaction_range base set 5")  -- Default reach (adjust as needed)
end

-- Function to toggle invisibility
function vanish()
    if is_invisible then
        host:sendChatCommand("/effect clear @s minecraft:invisibility")  -- Remove invisibility
        is_invisible = false
    else
        host:sendChatCommand("/effect give @s minecraft:invisibility 1000000 0 true")  -- Grant invisibility
        is_invisible = true
    end
end

-- Function to handle avatar load
function on_avatar_load()
    local commands_list = [[
Available Commands:
1. /gms - Set game mode to survival
2. /gmc - Set game mode to creative
3. /gmsp - Set game mode to spectator
4. /gma - Set game mode to adventure
5. /pl scale <value> - Set player's scale attribute
6. /pl speed <value> - Set player's movement speed attribute
7. /pl reset - Reset all player attributes
8. /reach <value> - Set player's block interaction range
9. /vanish - Toggle invisibility on and off

By NobleSkye
    ]]

    print(commands_list)
end

-- Event handler for chat messages
function events.chat_send_message(msg)
    -- Command without argument (for game modes)
    local commands = {
        ["/gms"] = gms,
        ["/gmc"] = gmc,
        ["/gmsp"] = gmsp,
        ["/gma"] = gma,
        ["/vanish"] = vanish
    }

    local command_function = commands[msg]
    
    -- Check if the message matches a simple command
    if command_function then
        command_function()  -- Call the function associated with the command
        return ""  -- Prevent the command from being sent to chat
    end

    -- Command with prefix /pl
    local prefix_commands = {
        ["/pl reset"] = reset_all_attributes
    }

    local prefix_command_function = prefix_commands[msg]
    
    -- Check if the message matches a prefix command
    if prefix_command_function then
        prefix_command_function()  -- Call the function associated with the prefix command
        return ""  -- Prevent the command from being sent to chat
    end

    -- Check if the message matches the /pl scale command with a number
    local scale_value = string.match(msg, "^/pl scale%s+(%d+%.?%d*)$")
    if scale_value then
        plscale_change(tonumber(scale_value))
        return ""  -- Prevent the command from being sent to chat
    end

    -- Check if the message matches the /pl speed command with a number
    local speed_value = string.match(msg, "^/pl speed%s+(%d+%.?%d*)$")
    if speed_value then
        plspeed_change(tonumber(speed_value))
        return ""  -- Prevent the command from being sent to chat
    end

    -- Check if the message matches the /reach command with a number
    local reach_value = string.match(msg, "^/reach%s+(%d+%.?%d*)$")
    if reach_value then
        reach_change(tonumber(reach_value))
        return ""  -- Prevent the command from being sent to chat
    end

    -- Return the message to be sent normally if it’s not a custom command
    return msg
end

-- Event handler for entity initialization
function events.entity_init()
    on_avatar_load()  -- Call the function when the avatar initializes
end






-- -- Define hotkeys and their functions
-- local function setupHotkeys()
--     local keybinds = keybinds or {}

--     local survivalKey = keybinds:newKeybind('Set Survival Mode', 'key.keyboard.f13')
--     survivalKey.press = function() gms() end

--     local creativeKey = keybinds:newKeybind('Set Creative Mode', 'key.keyboard.f14')
--     creativeKey.press = function() gmc() end

--     local spectatorKey = keybinds:newKeybind('Set Spectator Mode', 'key.keyboard.f15')
--     spectatorKey.press = function() gmsp() end

--     local adventureKey = keybinds:newKeybind('Set Adventure Mode', 'key.keyboard.f16')
--     adventureKey.press = function() gma() end
-- end

-- -- Call setupHotkeys() to initialize the hotkeys
-- setupHotkeys()
