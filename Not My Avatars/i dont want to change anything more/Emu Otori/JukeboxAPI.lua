--[[
      _       _        _                   _    ____ ___ 
     | |_   _| | _____| |__   _____  __   / \  |  _ \_ _|
  _  | | | | | |/ / _ \ '_ \ / _ \ \/ /  / _ \ | |_) | | 
 | |_| | |_| |   <  __/ |_) | (_) >  <  / ___ \|  __/| | 
  \___/ \__,_|_|\_\___|_.__/ \___/_/\_\/_/   \_\_|  |___|

        ____              _           _       ____                
       | __ ) _   _      | |_   _ ___| |_    / ___|   _ _ __ __ _ 
       |  _ \| | | |  _  | | | | / __| __|  | |  | | | | '__/ _` |
       | |_) | |_| | | |_| | |_| \__ \ |_   | |__| |_| | | | (_| |
       |____/ \__, |  \___/ \__,_|___/\__|___\____\__, |_|  \__,_|
              |___/                     |_____|   |___/           
--]]

-- Version: 1.1.0

--- @alias JukeboxAPI.LogType
--- | 'info' 
--- | 'warning' 
--- | 'error' 

--- @alias JukeboxAPI.Sounds
--- | table<integer, JukeboxAPI.Sound>

--- @class JukeboxAPI.Sound
--- @field sound_id Minecraft.soundID|string
--- @field item_id Minecraft.itemID
--- @field name string

--- @class JukeboxAPI.Config
--- @field target_page Page Target Action Wheel Page to fill with Registered Sounds
--- @field apply_zebra_stripping_to_actions boolean Should every second Action in the Target Action Wheel Page use Zebra Striping
--- @field back_action boolean Should add an action to go back to a category specified in `back_action_page`
--- @field back_action_page Page Page to go back to if a back action is made due to `back_action`
--- @field back_action_name string Name of the action that takes you back due to `back_action`
--- @field setTargetPage? fun(self: JukeboxAPI.Config, page: Page): JukeboxAPI.Config
--- @field setActionColor? fun(self: JukeboxAPI.Config, color?: Vector3|string): JukeboxAPI.Config
--- @field setActionZebraStripping? fun(self: JukeboxAPI.Config, boolean?: boolean): JukeboxAPI.Config
--- @field setBackAction? fun(self: JukeboxAPI.Config, boolean?: boolean, page?: Page, name?: string): JukeboxAPI.Config

--- @class JukeboxAPI.Colors
--- @field log JukeboxAPI.Colors.Log
--- @field action JukeboxAPI.Colors.Action

--- @alias JukeboxAPI.Colors.Log
--- | table<JukeboxAPI.LogType, string>

--- @class JukeboxAPI.Colors.Action
--- @field primary Vector3
--- @field secondary Vector3
--- @field hover Vector3
--- @field back Vector3
--- @field positive Vector3
--- @field negative Vector3
--- @field rotatedPrimarySecondary fun(self: JukeboxAPI.Colors.Action, index: integer): Vector3

local jukeboxAPI = {}

--- @type JukeboxAPI.Sounds
--- List of all registered Music Discs
jukeboxAPI.sounds = {}

--- @type JukeboxAPI.Config
jukeboxAPI.config = {
    target_page = nil,
    apply_zebra_stripping_to_actions = true,
    back_action = false,
    back_action_page = nil,
    back_action_name = 'Go Back',
}

--- @type JukeboxAPI.Colors
jukeboxAPI.colors = {
    log = {
        info = '§7',
        warning = '§e',
        error = '§c'
    },
    action = {
        primary = nil,
        secondary = nil,
        hover = nil,
        back = nil,
        positive = nil,
        negative = nil,

        ---Rotate between primary and secondary colors per index
        ---@param self JukeboxAPI.Colors.Action
        ---@param index integer
        ---@return Vector3
        rotatedPrimarySecondary = function (self, index)
            local color = nil

            if index % 2 == 0 then
                color = self.secondary
            else
                color = self.primary
            end
            return color
        end
    }
}

---Log tool used in JukeboxAPI
---@param log_type JukeboxAPI.LogType
---@param source string 
---@param message string
---@param ... any Message formatting arguments
local function logJukebox(log_type, source, message, ...)
    local color = jukeboxAPI.colors.log[log_type or 'info']
    log(string.format('%s|-- JukeboxAPI:%s --|', color, source))
    log(string.format(color .. message, ...))
end

--- @class JukeboxAPI.Events
--- @field ON_ACTION_STOP_ALL_SOUNDS JukeboxAPI.Events.StopAllSoundsAction | JukeboxAPI.Events.StopAllSoundsAction.trigger
--- @field ON_ACTION_PLAY_OR_STOP_SOUND JukeboxAPI.Events.PlayOrStopSoundAction | JukeboxAPI.Events.PlayOrStopSoundAction.trigger

--- @alias JukeboxAPI.Events.StopAllSoundsAction.register
--- | fun(self: table, func: JukeboxAPI.Events.StopAllSoundsAction.func)
--- @alias JukeboxAPI.Events.StopAllSoundsAction.trigger
--- | JukeboxAPI.Events.StopAllSoundsAction.func
--- @alias JukeboxAPI.Events.StopAllSoundsAction.func
--- | fun(action: Action, index: integer)

--- @class JukeboxAPI.Events.StopAllSoundsAction : table
--- @field register JukeboxAPI.Events.StopAllSoundsAction.register
--- @field events table<integer, JukeboxAPI.Events.StopAllSoundsAction.func>

--- @alias JukeboxAPI.Events.PlayOrStopSoundAction.register
--- | fun(self: table, func: JukeboxAPI.Events.PlayOrStopSoundAction.func): table<'skip', boolean>?
--- @alias JukeboxAPI.Events.PlayOrStopSoundAction.trigger 
--- | JukeboxAPI.Events.PlayOrStopSoundAction.func
--- @alias JukeboxAPI.Events.PlayOrStopSoundAction.func
--- | fun(action: Action, index: integer, state: boolean, sound: JukeboxAPI.Sound): table<integer, table<'skip', boolean>>?

--- @class JukeboxAPI.Events.PlayOrStopSoundAction : table
--- @field register JukeboxAPI.Events.PlayOrStopSoundAction.register
--- @field events table<integer, JukeboxAPI.Events.PlayOrStopSoundAction.func>

---Register a new Event
---@param self table
---@param func fun(...)
---@return boolean success
local function registerEvent(self, func)
    if type(func) ~= 'function' then
        logJukebox(
            'error', 'registerEvent()',
            'Unable to register a new Callback Event as provided function is actually "%s"!',
                type(func)
        )
        return false
    end

    table.insert(self.events, func)
    return true
end

---Trigger an Event
---@param self table
---@param ... any Function arguments
---@return table<integer, table<string, boolean>>? -- Function return flags
local function triggerEvent(self, ...)
    local returns = {}
    for _, func in pairs(self.events) do
        local call = func(...)
        if call then
            table.insert(returns, call)
        end
    end
    return #returns > 0 and returns or nil
end

--- @type JukeboxAPI.Events
jukeboxAPI.events = {
    ON_ACTION_STOP_ALL_SOUNDS = {
        register = registerEvent,
        events = {}
    },
    ON_ACTION_PLAY_OR_STOP_SOUND = {
        register = registerEvent,
        events = {}
    }
}

setmetatable(jukeboxAPI.events.ON_ACTION_STOP_ALL_SOUNDS --[[@as table]], {
    --- @type JukeboxAPI.Events.StopAllSoundsAction.trigger
    __call = triggerEvent
})
setmetatable(jukeboxAPI.events.ON_ACTION_PLAY_OR_STOP_SOUND --[[@as table]], {
    --- @type JukeboxAPI.Events.PlayOrStopSoundAction.trigger
    __call = triggerEvent
})

---Play/Stop a certain sound
---@param sound? Minecraft.soundID
---@param state? boolean
---@param x? number
---@param y? number
---@param z? number
function pings.PlayJukeboxSound(sound, state, x, y, z)
    if sound == nil or state == nil then
        sounds:stopSound()
        return
    end

    if not sounds:isPresent(sound) then
        logJukebox(
            'warning', 'pings.PlayJukeboxSound()',
            'Attempted to play an invalid sound "%s"! Skipping...',
            sound
        )
        return
    end

    if state then
        if x and y and z then
            sounds:playSound(sound, vec(x, y, z), 1, 1)
        else
            sounds:playSound(sound, player:getPos(), 1, 1)
        end
    else
        sounds:stopSound(sound)
    end
end

--- Get a list of Sounds registered
---@return JukeboxAPI.Sounds
---@nodiscard
function jukeboxAPI:getSounds()
    return self.sounds
end

--- Untoggle all Actions related to this API
---@param exception? integer If specified, this action index will not be untoggled
function jukeboxAPI:untoggleActions(exception)
    local page = self.config.target_page
    local action_count = #page:getActions()
    exception = exception or 0

    if action_count < 2 then
        return
    end

    for i = 2, action_count do
        if i ~= exception then
            local action = page:getAction(i)
            if action:isToggled() then
                action:toggled(false)
            end
        end
    end
end

--- Set Target Action Wheel Page to fill with Registered Sounds
---@param page Page
---@return JukeboxAPI.Config self
function jukeboxAPI.config:setTargetPage(page)
    if not page or type(page) ~= 'Page' then
        logJukebox(
            'error', 'setTargetPage()',
            '"%s" is not a valid page"!',
            page or 'nil'
        )
    else
        self.target_page = page
    end

    return self
end

--- Set the main color used for coloring the Action Wheel Actions
---@param color? Vector3|string
---@return JukeboxAPI.Config self
function jukeboxAPI.config:setActionColor(color)
    color = color or avatar:getColor() --[[@as Vector3|string]]
    local color_type = type(color)

    if color_type ~= "Vector3" and color_type ~= 'string' then
        logJukebox(
            'error', 'setActionColor()',
            '"%s" is not a valid color!',
            color or 'nil'
        )
    else
        local color_action = jukeboxAPI.colors.action

        color_action.primary = color_type == 'Vector3' and color or vectors.hexToRGB(color --[[@as string]])
        color_action.primary:mul(0.85, 0.85, 0.85)
        
        color_action.secondary = color_action.primary:copy():mul(1.5, 1.5, 1.5):applyFunc(function (v) return v > 1 and 1 or v end)
        color_action.hover = color_action.primary:copy():mul(0.75, 0.75, 0.75)
        color_action.back = vec(1.0, 0, 0)
        color_action.positive = vec(0, 0.75, 0)
        color_action.negative = vec(0.75, 0.25, 0.25)
    end
    
    return self
end

--- Should every second Action in the Target Action Wheel Page use Zebra Striping
---@param boolean? boolean
---@return JukeboxAPI.Config self
function jukeboxAPI.config:setActionZebraStripping(boolean)
    self.apply_zebra_stripping_to_actions = boolean and true or false

    return self
end

--- Should add an action to go back to a category
---@param boolean? boolean
---@param page? Page
---@param title? string
---@return JukeboxAPI.Config self
function jukeboxAPI.config:setBackAction(boolean, page, title)
    self.back_action = boolean and true or false
    
    if page and type(page) ~= 'Page' then
        logJukebox(
            'error', 'setBackAction()',
            '"%s" is not a valid page"!',
            page or 'nil'
        )
    else
        self.back_action_page = page
    end
    
    if title and type(title) ~= 'string' then
        logJukebox(
            'error', 'setBackAction()',
            '"%s" is not a valid name"!',
            title or 'nil'
        )
    else
        self.back_action_name = title
    end

    return self
end

--- Get an offset on the set target page from where Sound Actions start instead of meta buttons
---@return integer offset
function jukeboxAPI:getActionOffset()
    return self.config.back_action and 2 or 1
end

--- Takes a Minecraft Item (Music Disc) ID and converts it into a sound
---@param id Minecraft.itemID
---@return Minecraft.soundID
---@nodiscard
function jukeboxAPI.discToSound(id)
    ---@diagnostic disable-next-line: redundant-return-value
    return string.gsub(id, "(music_disc)_(.-)", function(disc, rest)
        return disc .. "." .. rest
    end, 1)
end

--- Compares `sound_id` and `item_id` with all registered Sounds and returns the name and index of an already registered Sound
---@param sound_id Minecraft.soundID
---@param item_id Minecraft.itemID
---@return JukeboxAPI.Sound|false duplicate
---@return integer? index
---@nodiscard
function jukeboxAPI:hasBeenRegistered(sound_id, item_id)
    for index, value in ipairs(self.sounds) do
        if value.sound_id == sound_id and value.item_id == item_id then
            return value, index
        end
    end
    return false
end

--- Add a new `JukeboxAPI.Sound` directly to `sounds`
--- Alternative of `jukeboxAPI.registerSound()`
--- NOTE: Use only when you sure you know what you're doing
---@param item_id Minecraft.itemID Item that is represented
---@param sound_id Minecraft.soundID Sound that is played
---@param name string Name of the Sound
---@param author? string Author of the Sound
---@param silent? boolean If `true` does not warn if a Sound was skipped when registering it
---@param ignore_duplicates? boolean If `true` does check for registered duplicates
---@return JukeboxAPI.Sound|false sound `JukeboxAPI.Sound` table if a new Sound was registered and `false` if something was skipped
---@return integer? index An index at which the new Sound was stored at
function jukeboxAPI:insertSound(item_id, sound_id, name, author, silent, ignore_duplicates)
    if not sounds:isPresent(sound_id) then
        if not silent then
            logJukebox(
                'warning', "insertSound()",
                'Attempted to register a Sound "%s" with an invalid Sound ID "%s"! Skipping...',
                name, sound_id or 'nil'
            )
        end
        return false
    end
    local duplicate = not ignore_duplicates and self:hasBeenRegistered(sound_id, item_id)
    if duplicate then
        if not silent then
            logJukebox(
                'warning', "insertSound()",
                'Attempted to register a Sound "%s" ("%s"), but is a duplicate of "%s" ("%s")! Skipping...',
                name, sound_id, duplicate.name, duplicate.sound_id
            )
        end
        return false
    end

    --- @type JukeboxAPI.Sound
    local tbl = {
        sound_id = sound_id,
        item_id = item_id,
        name = author and string.format("%s - %s", author, name) or name
    }
    table.insert(self.sounds, tbl)
    return tbl, #self.sounds
end

--- Register a new `JukeboxAPI.Sound`
---@param item_id Minecraft.itemID Item that is represented
---@param sound_id? Minecraft.soundID Sound that is played; If `nil` attempts to convert a sound id from the `item_id` field
---@param name? string Name of the Sound
---@param author? string Author of the Sound
---@param silent? boolean If `true` does not warn if a Sound was skipped when registering it
---@return JukeboxAPI.Sound|false sound `JukeboxAPI.Sound` table if a new Sound was registered and `false` if something was skipped
---@return integer? index An index at which the new Sound was stored at
function jukeboxAPI:registerSound(item_id, sound_id, name, author, silent)
    name = name or 'Unnamed'

    if not item_id or type(item_id) ~= 'string' then
        if not silent then
            logJukebox(
                'warning', "registerSound()",
                'Attempted to register a Sound "%s" with an invalid Item ID "%s"! Skipping...',
                name, item_id or 'nil'
            )
        end
        return false
    end

    if not sound_id or type(sound_id) ~= 'string' then
        sound_id = self.discToSound(item_id)
        if not sounds:isPresent(sound_id) then
            if not silent then
                logJukebox(
                    'warning', "registerSound()",
                    'Attempted to register a Sound "%s" that has a non-standard Sound ID "%s"! Skipping...',
                    name, sound_id or 'nil'
                )
            end
            return false
        end
    end

    local music, index = self:insertSound(item_id, sound_id, name, author)
    if not music then
        return false
    end
    self:createAction(music, index)
    return music, index
end

--- Register a new `JukeboxAPI.Sound` from the Avatar
---@param item_id Minecraft.itemID Item that is represented
---@param sound_path string A path to a Sound File in the Avatar
---@param name? string Name of the Sound
---@param author? string Author of the Sound
---@param silent? boolean If `true` does not warn if a Sound was skipped when registering it
---@return JukeboxAPI.Sound|false sound `JukeboxAPI.Sound` table if a new Sound was registered and `false` if something was skipped
---@return integer? index An index at which the new Sound was stored at
function jukeboxAPI:registerAvatarSound(item_id, sound_path, name, author, silent)
    name = name or 'Unnamed'

    if not item_id or type(item_id) ~= 'string' then
        if not silent then
            logJukebox(
                'warning', "registerAvatarSound()",
                'Attempted to register a Avatar Sound "%s" with an invalid Item ID "%s"! Skipping...',
                name, item_id or 'nil'
            )
        end
        return false
    end

    if not sound_path or type(sound_path) ~= 'string' then
        if not silent then
            logJukebox(
                'warning', "registerAvatarSound()",
                'Attempted to register an Avatar Sound "%s" with an invalid Sound Path "%s"! Skipping...',
                name, sound_path or 'nil'
            )
        end
        return false
    end

    if not sounds:isPresent(sound_path) then
        if not silent then
            logJukebox(
                'warning', "registerAvatarSound()",
                'Attempted to register an Avatar Sound "%s" with a Sound Path "%s", but that Sound Path does not contain a Sound File! Skipping...',
                name, sound_path or 'nil'
            )
        end
        return false
    end

    local music, index = self:insertSound(item_id, sound_path, name, author)
    if not music then
        return false
    end
    self:createAction(music, index)
    return music, index
end

--- Register multiple new `JukeboxAPI.Sound`
---@param tbl table<integer, {item_id: Minecraft.itemID, sound_id: Minecraft.soundID|nil, name: string|nil, author: string|nil}>
---@param silent? boolean If `true` does not warn if a Sound was skipped when registering it
function jukeboxAPI:registerSounds(tbl, silent)
    for _, args in ipairs(tbl) do
        self:registerSound(args.item_id, args.sound_id, args.name, args.author, silent)
    end
end

--- Register multiple new `JukeboxAPI.Sound` from the Avatar
---@param tbl table<integer, {item_id: Minecraft.itemID, sound_path: string|nil, name: string|nil, author: string|nil}>
---@param silent? boolean If `true` does not warn if a Sound was skipped when registering it
function jukeboxAPI:registerAvatarSounds(tbl, silent)
    for _, args in ipairs(tbl) do
        self:registerSound(args.item_id, args.sound_path, args.name, args.author, silent)
    end
end

--- Create and add a new action with a `JukeboxAPI.Sound` instance in a specified `index`;
--- Gives an error if target page has yet to be set via `jukeboxAPI.config:setTargetPage()`
---@param instance JukeboxAPI.Sound
---@param index? integer
---@return Action|false
function jukeboxAPI:createAction(instance, index)
    if not instance then
        return false
    end

    local api_events = self.events
    local cfg = self.config
    local action_colors = self.colors.action
    local page = cfg.target_page

    if not page or type(page) ~= 'Page' then
        logJukebox(
            'error', 'createAction()',
            'Cannot create a new Action Wheel Action as page has yet to be assigned via "jukeboxAPI.config:setTargetPage()"!'
        )
        return false
    end
    
    index = index or #page:getActions()+1

    local action = nil
    if index == 1 then
        local i = 1
        if cfg.back_action then
            action = page:newAction(i):color(action_colors.back)
            action
                :title(cfg.back_action_name or 'Go Back')
                :item("minecraft:barrier")
                :hoverColor(action_colors.back:copy():mul(0.75, 0.75, 0.75))
                :onLeftClick(function()
                    action_wheel:setPage(cfg.back_action_page)
                end)

            i = i + 1
        end

        action = page:newAction(i):color(cfg.apply_zebra_stripping_to_actions and self.colors.action:rotatedPrimarySecondary(i) or action_colors.primary)
        action
            :title('Stop all Sounds')
            :item("minecraft:structure_void")
            :hoverColor(action_colors.negative:copy():mul(0.75, 0.75, 0.75))
            :onLeftClick(function()
                self:untoggleActions()
                pings.PlayJukeboxSound()
                api_events.ON_ACTION_STOP_ALL_SOUNDS(action, i)
            end)
    end
    index = index + self:getActionOffset()

    action = page:newAction(index):color(cfg.apply_zebra_stripping_to_actions and self.colors.action:rotatedPrimarySecondary(index) or action_colors.primary)
    action
        :title(string.format('Play "%s"', instance.name))
        :item(instance.item_id)
        :hoverColor(action_colors.hover)
        :toggleTitle(string.format('Stop "%s"', instance.name))
        :onToggle(function(state)
            if state then
                local results = api_events.ON_ACTION_PLAY_OR_STOP_SOUND(action, index, state, instance)
                if results then
                    for _, result in ipairs(results) do
                        for key, value in pairs(result) do
                            if key == 'skip' and value then
                                return
                            end
                        end
                    end
                end
                self:untoggleActions(index)
                pings.PlayJukeboxSound()
                pings.PlayJukeboxSound(instance.sound_id, true, player:getPos():unpack())
                host:actionbar(string.format('{"translate": "Now Playing: %s"}', instance.name), true)
            else
                local results = api_events.ON_ACTION_PLAY_OR_STOP_SOUND(action, index, state, instance)
                if results then
                    for _, result in ipairs(results) do
                        for key, value in pairs(result) do
                            if key == 'skip' and value then
                                return
                            end
                        end
                    end
                end
                pings.PlayJukeboxSound(instance.sound_id)
            end
        end)

    return action
end

--- Register all vanilla Music Discs to `JukeboxAPI.Sounds`
function jukeboxAPI:registerVanillaDiscs()
    -- 1.0.0
    self:createAction(self:insertSound('minecraft:music_disc_11',                 'minecraft:music_disc.11',                 '11',                   'C418', true, true)--[[@as JukeboxAPI.Sound]])
    self:createAction(self:insertSound('minecraft:music_disc_13',                 'minecraft:music_disc.13',                 '13',                   'C418', true, true)--[[@as JukeboxAPI.Sound]])
    self:createAction(self:insertSound('minecraft:music_disc_blocks',             'minecraft:music_disc.blocks',             'Blocks',               'C418', true, true)--[[@as JukeboxAPI.Sound]])
    self:createAction(self:insertSound('minecraft:music_disc_cat',                'minecraft:music_disc.cat',                'Cat',                  'C418', true, true)--[[@as JukeboxAPI.Sound]])
    self:createAction(self:insertSound('minecraft:music_disc_chirp',              'minecraft:music_disc.chirp',              'Chirp',                'C418', true, true)--[[@as JukeboxAPI.Sound]])
    self:createAction(self:insertSound('minecraft:music_disc_far',                'minecraft:music_disc.far',                'Far',                  'C418', true, true)--[[@as JukeboxAPI.Sound]])
    self:createAction(self:insertSound('minecraft:music_disc_mall',               'minecraft:music_disc.mall',               'Mall',                 'C418', true, true)--[[@as JukeboxAPI.Sound]])
    self:createAction(self:insertSound('minecraft:music_disc_mellohi',            'minecraft:music_disc.mellohi',            'Mellohi',              'C418', true, true)--[[@as JukeboxAPI.Sound]])
    self:createAction(self:insertSound('minecraft:music_disc_stal',               'minecraft:music_disc.stal',               'Stal',                 'C418', true, true)--[[@as JukeboxAPI.Sound]])
    self:createAction(self:insertSound('minecraft:music_disc_strad',              'minecraft:music_disc.strad',              'Strad',                'C418', true, true)--[[@as JukeboxAPI.Sound]])
    self:createAction(self:insertSound('minecraft:music_disc_ward',               'minecraft:music_disc.ward',               'Ward',                 'C418', true, true)--[[@as JukeboxAPI.Sound]])
    -- 1.4.4
    self:createAction(self:insertSound('minecraft:music_disc_wait',               'minecraft:music_disc.wait',               'Wait',                 'C418', true, true)--[[@as JukeboxAPI.Sound]])
    -- 1.16.0
    self:createAction(self:insertSound('minecraft:music_disc_pigstep',            'minecraft:music_disc.pigstep',            'Pigstep',              'Lena Raine', true, true)--[[@as JukeboxAPI.Sound]])
    -- 1.18.0
    self:createAction(self:insertSound('minecraft:music_disc_otherside',          'minecraft:music_disc.otherside',          'Otherside',            'Lena Raine', true, true)--[[@as JukeboxAPI.Sound]])
    -- 1.19.0
    self:createAction(self:insertSound('minecraft:music_disc_5',                  'minecraft:music_disc.5',                  '5',                    'Samuel Åberg', true, true)--[[@as JukeboxAPI.Sound]])
    -- 1.20.0
    self:createAction(self:insertSound('minecraft:music_disc_relic',              'minecraft:music_disc.relic',              'Relic',                'Aaron Cherof', true, true)--[[@as JukeboxAPI.Sound]])
    -- 1.21.0
    self:createAction(self:insertSound('minecraft:music_disc_precipice',          'minecraft:music_disc.precipice',          'Precipice',            'Aaron Cherof', true, true)--[[@as JukeboxAPI.Sound]])
    self:createAction(self:insertSound('minecraft:music_disc_creator_music_box',  'minecraft:music_disc.creator_music_box',  'Creator (Music Box)',  'Lena Raine', true, true)--[[@as JukeboxAPI.Sound]])
    self:createAction(self:insertSound('minecraft:music_disc_creator',            'minecraft:music_disc.creator',            'Creator',              'Lena Raine', true, true)--[[@as JukeboxAPI.Sound]])
end

jukeboxAPI.config:setActionColor()

return jukeboxAPI
