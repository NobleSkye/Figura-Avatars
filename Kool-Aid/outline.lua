--asof's astounding outline system!
local makeSolid = true


local blankTexture = textures:newTexture("blank_tex",1,1)
blankTexture:setPixel(0,0,vec(1,1,1)):save()

local camDist = 0

events.RENDER:register(function (delta, context)
  local cameraPos = client:getCameraPos()
  local playerPos = player:getPos()
  if cameraPos.y>playerPos.y+2 then
    cameraPos.y=cameraPos.y-2
  elseif cameraPos.y>playerPos.y then
    cameraPos.y=playerPos.y
  end
  camDist = (cameraPos-playerPos):length()
end)

local function applyfunc(fn,a,b)
  local vec = vec(0,0,0)
  for l=1,3 do
    vec[l]=fn(a[l],b[l])
  end
  return vec
end


---func desc
---@param part ModelPart the part to recursively outline! any cubes/groups with "nooutline" somewhere in their name will be skipped.
---@param conf table
---@param conf.color Vector3 a color, given in the standard figura format of 0-1 red green and blue.
---@param conf.useBaseTexture boolean if true when creating the outline, it will not override the texture with a fully white blank texture. good for transparent textures, i supppose.
local function outline(part,conf)
  
  if part:getName():find("nooutline") then return end
  if #part:getChildren() == 0 then
    local verts = {}
    --printTable(part:getAllVertices())
    for texName,vertsTex in pairs(part:getAllVertices()) do
      for _,vert in ipairs(vertsTex) do table.insert(verts,vert) end
    end
    if #verts > 0 then
      local pos = vec(0,0,0)
      local min = vec(1,1,1)*math.huge
      local max = vec(1,1,1)*-math.huge
      for _,vert in ipairs(verts) do
        min = applyfunc(math.min,min,vert:getPos())
        max = applyfunc(math.max,max,vert:getPos())
        pos = pos + vert:getPos()
      end
      local size = max-min
      part:setPivot(pos/#verts)
      local copy = part:copy(part:getName().."_nooutline")
      local outer = part:newPart(part:getName().."_outer_nooutline")
      outer:addChild(copy)

      local isNose = part:getName():find("nose")

      
      if not conf.useBaseTexture then
        copy:setPrimaryTexture("CUSTOM",blankTexture)
        copy:setSecondaryTexture("CUSTOM",blankTexture)
      end

      copy:setPreRender(function()
        copy:color(conf.color)

        local s = 1+0.15/math.clamp(camDist-1,0.25,1)
        if isNose then s = 1+0.4/math.clamp(camDist-1,0.25,1) end

        --comment this out if you don't want t
        local scale = (size + 0.5 + math.log(camDist/1+1,4)) / size
        outer:scale(scale)

        --move it behind the avatar visually
        copy:setMatrix(matrices.mat4(
          vectors.vec4(s,0,0,0),
          vectors.vec4(0,s,0,0),
          vectors.vec4(0,0,s,0),
          vectors.vec4(0,0,0,s)
        ))
      end)
    end
  end
  for i,child in ipairs(part:getChildren()) do
    outline(child,conf)
  end
end

return outline