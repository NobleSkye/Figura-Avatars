

names = {
    ["ENTITY"] = '[{"text":"Skye"}]',
    ["LIST"] = '[{"color":"#fc97fc","text":"ᴜᴡᴜ "},' ..
    '{"color":"#535353","text":"| "},' ..
    '{"color":"#fc97fc","text":"N"},' ..
    '{"color":"#fba8fc","text":"o"},' ..
    '{"color":"#fbb1fc","text":"b"},' ..
    '{"color":"#fcbafc","text":"l"},' ..
    '{"color":"#fcc3fc","text":"e"},' ..
    '{"color":"#fcccfb","text":"S"},' ..
    '{"color":"#fcd4fb","text":"k"},' ..
    '{"color":"#fcdbfb","text":"y"},' ..
    '{"color":"#fce2fb","text":"e"}]',
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