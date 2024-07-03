

names = {
    ["ENTITY"] = '[{"text":"Skye"}]',
    ["LIST"] = '[{"text":"Skye :trans:"}]',
    ["CHAT"] = '[{"text":"Skye"}]'
}

getAFK = require("Slyme_AFK")

events.TICK:register(function()
    if getAFK() then
        local min = math.floor(getAFK()/1200)
        local sec = math.floor((getAFK()/20)%60)
        nameAdd = {
            ["ENTITY"] = '{"text":"\n[ AFK - ' .. tostring(min) .. 'm ' .. tostring(sec) .. 's ]","color":"gray","bold":false}',
            ["CHAT"] = '{"text":""}'
        }
        if #tostring(sec) < 2 then
            formattedSec = tostring("0" .. sec)
        else
            formattedSec = tostring(sec)
        end
        nameAdd["LIST"] = '{"text":" [ ' .. tostring(min) .. ":" .. formattedSec .. ' ]","color":"gray","bold":false}'
    else
        nameAdd = {["ENTITY"]='{"text":""}',["LIST"]='{"text":""}',["CHAT"]='{"text":""}'}
    end
    for k, v in pairs(names) do
        nameplate[k]:setText('[' .. v .. ',' .. nameAdd[k] .. ']')
    end
end)

return function(e, l, c)
    if e then names.ENTITY = e end
    if l then names.LIST = l end
    if c then names.CHAT = c end
end