-- list of names you will get ping sound for, need to be lower case
local pingNames = {
    avatar:getEntityName():lower()
 }
 
 local repeatMessageSuffix = '{"text":" [x%s]","color":"dark_gray"}'
 
 local textRules = {
    {what = '#%x%x%x%x%x%x', with = function(color) -- color normal hex codes
       return {text = color, color = color}
    end},
    {what = '#(%x)(%x)(%x)', with = function(r, g, b) -- color short hex codes
       return {text = '#'..r..g..b, color = '#'..r..r..g..g..b..b}
    end},
    {what = 'https?://%S+', with = function(text) -- color and make clickable links
       return {
          text = text,
          color = '#cba6f7',
          underlined = true,
          clickEvent = {
             action = 'open_url',
             value = text
          }
       }
    end}
 }
 
 -- code
 local history = {}
 local repeatCount = {}
 
 local function applyTextRules(text)
    local tbl = {}
    local currentText = text
    for _ = 1, #text do
       if currentText == '' then break end
       local ruleDistance = math.huge
       local closestRule
       for _, v in pairs(textRules) do
          local a, b = currentText:find(v.what)
          if a and a < ruleDistance then
             ruleDistance = a
             closestRule = {a, b, v}
          end
       end
       if closestRule then
          local a, b, v = closestRule[1], closestRule[2], closestRule[3]
          table.insert(tbl, currentText:sub(1, a - 1))
          table.insert(tbl, v.with(currentText:sub(a, b):match(v.what)))
          currentText = currentText:sub(b + 1, -1)
       else break end
    end
    table.insert(tbl, currentText)
    return tbl[2] and tbl
 end
 
 local function formatText(components)
    for i, component in ipairs(components) do
       if type(component) == 'table' then
          if component.extra then formatText(component.extra) end
          if component.with then formatText(component.with) end
          if component[1] then formatText(component) end -- check if array
          if component.text then
             local extra = applyTextRules(component.text)
             if extra then
                table.insert(extra, component.extra)
                component.text = ''
                component.extra = extra
             end
          end
       elseif type(component) == 'string' then
          local text = applyTextRules(component)
          if text then
             components[i] = {
                text = '',
                extra = text
             }
          end
       end
    end
 end
 
 function events.chat_receive_message(msg, json)
    if not msg then return end
    -- find duplicated messages
    for i = 1, 3 do
       if history[i] == msg then
          host:setChatMessage(i)
          table.remove(history, i)
          repeatCount[msg] = (repeatCount[msg] or 1) + 1
          json = '['..json..','..string.format(repeatMessageSuffix, repeatCount[msg])..']'
          break
       end
    end
    -- add to history
    table.insert(history, 1, msg)
    if #history > 5 then
       repeatCount[history[#history]] = nil
       table.remove(history)
    end
    -- decode json
    local decodedJson = parseJson(json)
    -- ping
    local entityName = avatar:getEntityName()
    local canPing = type(decodedJson) == 'table' and decodedJson.translate == 'chat.type.text' and type(decodedJson.with) == 'table' and decodedJson.with[1] ~= entityName
                    or msg:match('^<([^>]+)> .') and msg:sub(1, #entityName + 3) ~= '<'..entityName..'> '
    if canPing then
       local messageLower = msg:lower()
       for _, v in pairs(pingNames) do
          if messageLower:find(v) then
            --  sounds:playSound('minecraft:block.note_block.pling', client:getCameraPos(), 1, 1.2)
            --  host:setActionbar('BEEP', true)
             break
          end
       end
    end
    -- raw text + shift click to suggest
    decodedJson = {
       {
          text = '',
          hoverEvent = {action = 'show_text', contents = msg:gsub('Â§k', '')},
          insertion = msg,
       },
       {
          parseJson(json)
       }
    }
    -- format message
    formatText({decodedJson})
    -- convert back to json
    json = toJson(decodedJson)
    -- return
    return json
 end