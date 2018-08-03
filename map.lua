local tileSet = love.graphics.newImage("sprite/tileset/tileSet_1.png")

local Map = {}
Map.Tmap = {
  {0,1,2,3},
  {0}
}


function Map:draw(posCam)

  for n,v in pairs(Map.Tmap) do
    for i,u in pairs(v) do

      local l = u % (tileSet:getWidth() / 32)
      print(l)
      local c = math.floor(u / (tileSet:getWidth() / 32))
      local currX = l * 32
      local currY = c * 32

      local sx = -5000 + i *32  - posCam.x + width/2 - 25
      local sy = -5000 + n *32  - posCam.y + height/2 - 25
      local q = love.graphics.newQuad(currX, currY, 32, 32, tileSet:getDimensions())
      love.graphics.draw(tileSet, q, sx ,sy)
    end
  end
  love.graphics.setColor(255, 255, 255)


end

return Map
