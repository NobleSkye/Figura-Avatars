

-- Define your player Skull here The normal Skull/Head that shows when no blockToFind is found
-- ie models.plushie.Skull

-- playerSkull = models.Plushie.Skull
-- -- plushieState is the skulls that show when blockToFind is found
-- plushieState = models.plushieState.Skull


local plushieState = models.plushieState.Skull
local playerSkull = models.Plushie.Skull

local blockToFind = {
    overworld = "minecraft:brown_stained_glass_pane",
    nether = "minecraft:red_stained_glass_pane",
    _end = ":minecraft:yellow_stained_glass_pane",
}

plushieState:setPrimaryRenderType("EMISSIVE")
plushieState:setScale(0)
plushieState:setPos(0, 0, 0)
plushieState:setRot(0, 0, 0)


function events.entity_init()
    local block = world.getBlockState(player:getPos())
end

function events.skull_render(delta, block, item, entity, ctx)
    if ctx == "BLOCK" then 
        local ceiling = block:above()
        plushieState:setVisible(ceiling.id == blockToFind.overworld or ceiling.id == blockToFind.nether or ceiling.id == blockToFind._end)
        plushieState.Overworld:setVisible(ceiling.id == blockToFind.overworld)
        plushieState.Nether:setVisible(ceiling.id == blockToFind.nether)
        plushieState.End:setVisible(ceiling.id == blockToFind._end)
        playerSkull:setVisible(not (ceiling.id == blockToFind.overworld or ceiling.id == blockToFind.nether or ceiling.id == blockToFind._end))
    else
        plushieState:setVisible(false)
        playerSkull:setVisible(true)
    end
end

function events.skull_render(delta, block, item, entity, ctx)
    if ctx == "BLOCK" then
      local ceiling = world.getBlockState(block:getPos() + vec(0, 1, 0))
      plushieState:setVisible(ceiling.id == "minecraft:brown_stained_glass_pane")
      playerSkull:setVisible(not (ceiling.id == "minecraft:brown_stained_glass_pane"))
    else
        plushieState:setVisible(false)
        playerSkull:setVisible(true)
  end
end