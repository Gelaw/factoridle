local tileSet = love.graphics.newImage("sprite/tileset/tileSet_1.png")

local Map = {}
Map.Tmap = {}
for j = 1, 100, 1 do
  Map.Tmap[j] = {}
  for i = 1, 100, 1 do
    Map.Tmap[j][i] = math.floor(math.random(0, 3))
  end
end

function Map:draw(posCam)

  -- for n,x in pairs(Map.Tmap) do
  --   for i,y in pairs(x) do
    for x = (width/2)%32- posCam.x%32 ,  width + 32, 32 do
      for y = (height/2)%32- posCam.y%32,  height + 32, 32 do
        local i = math.floor((x-posCam.x-5000)/32)
        local j = math.floor((y-posCam.y-5000)/32)
        print(i,j)
        if Map.Tmap[j] and Map.Tmap[j][i] then

          local l = (Map.Tmap[j][i]) % (tileSet:getWidth() / 32)
          local c = math.floor( (Map.Tmap[j][i]) / (tileSet:getWidth() / 32))
          local currX = l * 32
          local currY = c * 32
          local q = love.graphics.newQuad(currX, currY, 32, 32, tileSet:getDimensions())

          love.graphics.draw(tileSet, q, x ,y)
        end
      end
    end

end

return Map
