-- __________                                _______ ________ ________
-- ___  ____/______ ______________  __       ___    |___  __ \____  _/
-- __  __/   _  __ `/__  ___/__  / / /       __  /| |__  /_/ / __  /  
-- _  /___   / /_/ / _(__  ) _  /_/ /        _  ___ |_  ____/ __/ /   
-- /_____/   \__,_/  /____/  _\__, /         /_/  |_|/_/      /___/   
--                           /____/                                   

-- worldModel = models.model.WORLD

-- Vars
armor = boolean
armorHelmet = boolean
armorChestplate = boolean
armorLeggings = boolean
armorBoots = boolean
CAPE = boolean
ELYTRA = boolean
state = boolean

vanilla_model.ARMOR:setVisible(armor)
vanilla_model.HELMET:setVisible(armorHelmet)
vanilla_model.CHESTPLATE:setVisible(armorChestplate)
vanilla_model.LEGGINGS:setVisible(armorLeggings)
vanilla_model.BOOTS:setVisible(armorBoots)
vanilla_model.CAPE:setVisible(CAPE)
vanilla_model.ELYTRA:setVisible(ELYTRA)

function debug()
    print("armor: ", armor)
    print("armorHelmet: ", armorHelmet)
    print("armorChestplate: ", armorChestplate)
    print("armorLeggings: ", armorLeggings)
    print("armorBoots: ", armorBoots)
    print("CAPE: ", CAPE)
    print("ELYTRA: ", ELYTRA)
    print(aaa)
end

function showModel(varName, aaa)
    if varName == "armor" then
        aaa not aaa
        vanilla_model.ARMOR:setVisible(armor)
    elseif varName == "armorHelmet" then
        armorHelmet = aaa
        vanilla_model.HELMET:setVisible(armorHelmet)
    elseif varName == "armorChestplate" then
        armorChestplate = aaa
        vanilla_model.CHESTPLATE:setVisible(armorChestplate)
    elseif varName == "armorLeggings" then
        armorLeggings = aaa
        vanilla_model.LEGGINGS:setVisible(armorLeggings)
    elseif varName == "armorBoots" then
        armorBoots = aaa
        vanilla_model.BOOTS:setVisible(armorBoots)
    elseif varName == "CAPE" then
        CAPE = aaa
        vanilla_model.CAPE:setVisible(CAPE)
    elseif varName == "ELYTRA" then
        ELYTRA = aaa
        vanilla_model.ELYTRA:setVisible(ELYTRA)
    end
end

-- Example action to place world object (commented out)
-- local f = vec(0,0,0)
-- avatar:store("posfiretome", f)
-- function pings.book() 
--    worldPOS = player:getPos()
--    worldModel:setPos((worldPOS*16))
--    avatar:store("posfiretome", worldPOS)
-- end
-- local action = mainPage:newAction()
--     :title("Place World Object")
--     :item("minecraft:book")
--     :hoverColor(1, 1, 1)
--     :onLeftClick(pings.book)

-- Example keybind to toggle visibility of armor
local toggleArmorKey = keybinds:newKeybind("Toggle Armor", "key.keyboard.h")
toggleArmorKey.press = function()
    armor = not armor
    showModel("armor", armor)
    print("Toggled armor to", armor)
end
