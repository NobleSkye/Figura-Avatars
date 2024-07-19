--       ___           ___           ___           ___           ___           ___           ___                    ___                                
--      /  /\         /  /\         /  /\         /  /\         /  /\         /  /\         /  /\                  /  /\          ___            ___   
--     /  /::\       /  /::\       /  /::|       /  /::|       /  /::\       /  /::|       /  /::\                /  /::\        /  /\          /__/\  
--    /  /:/\:\     /  /:/\:\     /  /:|:|      /  /:|:|      /  /:/\:\     /  /:|:|      /  /:/\:\              /  /:/\:\      /  /::\         \__\:\ 
--   /  /:/  \:\   /  /:/  \:\   /  /:/|:|__   /  /:/|:|__   /  /::\ \:\   /  /:/|:|__   /  /:/  \:\            /  /::\ \:\    /  /:/\:\        /  /::\
--  /__/:/ \  \:\ /__/:/ \__\:\ /__/:/_|::::\ /__/:/_|::::\ /__/:/\:\_\:\ /__/:/ |:| /\ /__/:/ \__\:|          /__/:/\:\_\:\  /  /::\ \:\    __/  /:/\/
--  \  \:\  \__\/ \  \:\ /  /:/ \__\/  /~~/:/ \__\/  /~~/:/ \__\/  \:\/:/ \__\/  |:|/:/ \  \:\ /  /:/          \__\/  \:\/:/ /__/:/\:\_\:\  /__/\/:/~~ 
--   \  \:\        \  \:\  /:/        /  /:/        /  /:/       \__\::/      |  |:/:/   \  \:\  /:/                \__\::/  \__\/  \:\/:/  \  \::/    
--    \  \:\        \  \:\/:/        /  /:/        /  /:/        /  /:/       |__|::/     \  \:\/:/                 /  /:/        \  \::/    \  \:\    
--     \  \:\        \  \::/        /__/:/        /__/:/        /__/:/        /__/:/       \__\__/                 /__/:/          \__\/      \__\/    
--      \__\/         \__\/         \__\/         \__\/         \__\/         \__\/                                \__\/                               




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

-- Function to handle chat messages
function events.chat_send_message(msg)
    -- Check the command and call the corresponding function
    if msg == "/gms" then
        gms()
        return ""  -- Prevent the command from being sent to chat
    elseif msg == "/gmc" then
        gmc()
        return ""  -- Prevent the command from being sent to chat
    elseif msg == "/gmsp" then
        gmsp()
        return ""  -- Prevent the command from being sent to chat
    elseif msg == "/gma" then
        gma()
        return ""  -- Prevent the command from being sent to chat
    end

    -- Return the message to be sent normally if it’s not a custom command
    return msg
end
