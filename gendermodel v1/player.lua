-- parts of this code are derived from KattArmor by @kitcat962 (id 289896419291168775) from figura's discord.

-- color values for each trim type
local trimMaterials = {
    ["amethyst"] = (vectors.intToRGB(0x9a5cc6)),
    ["copper"] = (vectors.intToRGB(0xb4684d)),
    ["diamond"] = (vectors.intToRGB(0x6eecd2)),
    ["emerald"] = (vectors.intToRGB(0x0ec754)),
    ["gold"] = (vectors.intToRGB(0xecd93f)),
    ["iron"] = (vectors.intToRGB(0xbfc9c8)),
    ["lapis"] = (vectors.intToRGB(0x1c4d9c)),
    ["netherite"] = (vectors.intToRGB(0x443a3b)),
    ["quartz"] = (vectors.intToRGB(0xf6eadf)),
    ["redstone"] = (vectors.intToRGB(0xbd2008)),
}
_ = nil               -- shorthand for nil in method calls
local chestplate = {} -- keep track of existing chestplate

---@type boolean
---@diagnostic disable-next-line: assign-type-mismatch
local armorRenderEnabled = config:load("armorIsEnabled")
if not armorRenderEnabled then armorRenderEnabled = false end

local function chestplateEqual(chestplateItem)
    local currentChestplate = player:getItem(5)
    return chestplateItem:hasGlint() == currentChestplate:hasGlint() and
        chestplateItem.id == currentChestplate.id
end

local function setBoobScale(scale)
    local newscale = math.log(scale, 16) + 1 -- ramp to make sure scaling is reasonable
    models.body.Body.Body:setOffsetPivot(_, -1, -2)
    models.body.Body.Jacket:setOffsetPivot(_, -1, -2)
    models.body.Body.Chestplate.ChestplateBoob:setOffsetPivot(_, -1, 0)
    models.body.Body.ChestplateTrim.ChestplateTrimBoob:setOffsetPivot(_, -1, 0)
    models.body.Body.Body:setScale(1, newscale, newscale * DepthScaleFactor)
    models.body.Body.Jacket:setScale(1, newscale, newscale * DepthScaleFactor)
    models.body.Body.Chestplate.ChestplateBoob:setScale(1, newscale, newscale * DepthScaleFactor)
    models.body.Body.ChestplateTrim.ChestplateTrimBoob:setScale(1, newscale,
        newscale * DepthScaleFactor)
    local body_matrix = matrices.mat3()
    local jacket_matrix = matrices.mat3()
    local armor_matrix = matrices.mat3()
    body_matrix:scale(1, newscale, 1)
    armor_matrix:scale(1, newscale, 1)
    jacket_matrix:scale(1, newscale, 1)
    body_matrix:translate(0, (newscale * UVFactorBody + UVOffsetBody) / 32)
    jacket_matrix:translate(0, (newscale * UVFactorJacket + UVOffsetJacket) / 32)
    armor_matrix:translate(0, (newscale * UVFactorChestplate + UVOffsetChestplate) / 32)
    models.body.Body.Body:setUVMatrix(body_matrix)
    models.body.Body.Jacket:setUVMatrix(jacket_matrix)
    models.body.Body.Chestplate.ChestplateBoob:setUVMatrix(armor_matrix)
    models.body.Body.ChestplateTrim.ChestplateTrimBoob:setUVMatrix(armor_matrix)
end

local function setChestplateRendering()
    models.body.Body.Chestplate:setVisible(armorRenderEnabled)
    models.body.Body.ChestplateTrim:setVisible(armorRenderEnabled)
    -- disabling the pivots hides the shoulder pieces of the chestplate and vice versa
    models.body.LeftArm.LeftShoulderPivot:setVisible(armorRenderEnabled)
    models.body.RightArm.RightShoulderPivot:setVisible(armorRenderEnabled)
    if armorRenderEnabled ~= true then return end
    chestplate = player:getItem(5)
    local material = string.reverse(chestplate.id:match(("^.*:(.*)"))):sub(12):reverse()
    material = material:len() ~= 0 and material or "none"
    if material == "none" then
        return
    end
    -- golden items do not use golden in texture, work around that
    if material == "golden" then
        material = "gold"
    end
    local color = 0xFFFFFF
    -- set armor color
    if material == "leather" then
        local tag = chestplate:getTag()
        color = tag and tag.display and tag.display.color or
            0xA06540 -- color chestplate if leather, defaulting to default brown
    end
    models.body.Body.Chestplate:setColor(vectors.intToRGB(color))

    -- set rendering properties of chestplate
    models.body.Body.Chestplate:setPrimaryTexture("RESOURCE",
        "minecraft:textures/models/armor/" .. material .. "_layer_1.png")
    models.body.Body.Chestplate:setSecondaryRenderType(chestplate:hasGlint() and "GLINT" or "NONE")

    -- trim logic
    local trim = chestplate:getTag().Trim
    models.body.Body.ChestplateTrim:setVisible(trim ~= nil)
    if trim ~= nil then
        local trimPattern = chestplate:getTag().Trim.pattern:match(("^.*:(.*)"))
        local trimMaterial = chestplate:getTag().Trim.material:match(("^.*:(.*)"))
        models.body.Body.ChestplateTrim:setPrimaryTexture("RESOURCE",
            "minecraft:textures/trims/models/armor/" .. trimPattern .. ".png")
        models.body.Body.ChestplateTrim:setColor(trimMaterials[trimMaterial])
    end
end

local function toggleArmor()
    -- toggle vanilla pieces
    vanilla_model.BOOTS:setVisible(armorRenderEnabled)
    vanilla_model.LEGGINGS:setVisible(armorRenderEnabled)
    vanilla_model.HELMET:setVisible(armorRenderEnabled)
    setChestplateRendering()
end



local function actionWheel()
    local armorOnTexture = textures:fromVanilla("actionWheelArmorEnableItem",
        "minecraft:textures/item/netherite_chestplate.png")
    local armorOffTexture = textures:fromVanilla("actionWheelArmorDisableItem",
        "minecraft:textures/item/barrier.png")
    local armorSettingsPage = action_wheel:newPage("GenderModel Actions")
    action_wheel:setPage(armorSettingsPage)
    local action = armorSettingsPage:newAction()
    action
        :setTitle("Turn armor " .. ((not armorRenderEnabled) and "on" or "off"))
        :setTexture(
            armorRenderEnabled and armorOnTexture or armorOffTexture, _, _, _,
            _, .8)
        :setToggled(armorRenderEnabled)
    local function toggleFunc(state, act)
        config:save("armorIsEnabled", state)
        armorRenderEnabled = state
        act
            :setTitle("Turn armor " .. ((not state) and "on" or "off"))
            :setTexture(
                state and armorOnTexture or armorOffTexture, _, _, _,
                _, .8)
            :setToggled(armorRenderEnabled)
        toggleArmor()
    end
    action
        :setOnToggle(toggleFunc)
end

---@diagnostic disable-next-line: inject-field
function events.entity_init()
    -- set textures
    models.body.Body.Body:setPrimaryTexture("SKIN")
    models.body.Body.Jacket:setPrimaryTexture("SKIN")
    vanilla_model.CHESTPLATE:setVisible(false) -- hides chestplate body, pivots set for shoulders
    setBoobScale(BoobScale)                    -- set boob scale from config.lua
    chestplate = player:getItem(5)             -- set up chestplate
    toggleArmor()                              -- set armor render state once
    actionWheel()                              -- set up action wheel
end

---@diagnostic disable-next-line: inject-field
function events.tick()
    if not chestplateEqual(chestplate) then
        setChestplateRendering()
    end
end
