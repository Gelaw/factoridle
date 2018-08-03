local tileSet = love.graphics.newImage("sprite/tileset/tileSet_1.png")

local Map = {}

function Map:init()
  Map.seed = 5312
  Map.chunksize = 6
  Map.chunknumber = 30
  self:generateMap()
  self:cleanSmallchunks()
  self:arrangeChunksBorders()
end

function Map:generateMap()
  math.randomseed(Map.seed)
  grounds = {}
  for l = 0, 1 do
    for c = 0, 1 do
      table.insert(grounds, {x=4*l+0.5, y=3*c+1.5})
    end
  end
  Map.Tmap = {}
  for j = 1, Map.chunknumber*Map.chunksize, 1 do
    Map.Tmap[j] = {}
    for i = 1, Map.chunknumber*Map.chunksize, 1 do
      Map.Tmap[j][i] = {}
      if j%Map.chunksize==1 and i%Map.chunksize==1 then
        if Map.Tmap[j-1] and Map.Tmap[j-1][i] and Map.Tmap[j] and Map.Tmap[j][i-1] then
          if Map.Tmap[j-1][i][1] == Map.Tmap[j][i-1][1] then
            if math.random() < 0.3 then
              table.insert(Map.Tmap[j][i], grounds[math.random(#grounds)])
            else
              table.insert(Map.Tmap[j][i], Map.Tmap[j-1][i][1])
            end
          elseif math.random() < 0.75 then
            if math.random() < 0.5 then
              table.insert(Map.Tmap[j][i], Map.Tmap[j-1][i][1])
            else
              table.insert(Map.Tmap[j][i], Map.Tmap[j][i-1][1])
            end
          else
            table.insert(Map.Tmap[j][i], grounds[math.random(#grounds)])
          end
        elseif Map.Tmap[j-1] and Map.Tmap[j-1][i] then
          if math.random() < 0.75 then
            table.insert(Map.Tmap[j][i], Map.Tmap[j-1][i][1])
          else
            table.insert(Map.Tmap[j][i], grounds[math.random(#grounds)])
          end
        elseif Map.Tmap[j] and Map.Tmap[j][i-1] then
          if math.random() < 0.75 then
            table.insert(Map.Tmap[j][i], Map.Tmap[j][i-1][1])
          else
            table.insert(Map.Tmap[j][i], grounds[math.random(#grounds)])
          end
        else
          table.insert(Map.Tmap[j][i], grounds[math.random(#grounds)])
        end
      elseif i%Map.chunksize == 1 then
        table.insert(Map.Tmap[j][i], Map.Tmap[j-1][i][1])
      else
        table.insert(Map.Tmap[j][i], Map.Tmap[j][i-1][1])
      end
    end
  end
end

function Map:cleanSmallchunks()
  for j = 1, Map.chunknumber*Map.chunksize, Map.chunksize do
    for i = 1, Map.chunknumber*Map.chunksize, Map.chunksize do
      local isLonely = true
      local neighs = {}
      if Map.Tmap[j-1] and Map.Tmap[j-1][i] then
        table.insert(neighs, Map.Tmap[j-1][i][1])
        if Map.Tmap[j-1][i][1]==Map.Tmap[j][i][1] then
          isLonely = false
        end
      end
      if Map.Tmap[j+Map.chunksize] and Map.Tmap[j+Map.chunksize][i] then
        table.insert(neighs, Map.Tmap[j+Map.chunksize][i][1])
        if Map.Tmap[j+Map.chunksize][i][1]==Map.Tmap[j][i][1] then
          isLonely = false
        end
      end
      if Map.Tmap[j] and Map.Tmap[j][i-1] then
        table.insert(neighs,Map.Tmap[j][i-1][1])
        if Map.Tmap[j][i-1][1]==Map.Tmap[j][i][1] then
          isLonely = false
        end
      end
      if Map.Tmap[j] and Map.Tmap[j][i+Map.chunksize] then
        table.insert(neighs,Map.Tmap[j][i+Map.chunksize][1])
        if Map.Tmap[j][i+Map.chunksize][1]==Map.Tmap[j][i][1] then
          isLonely = false
        end
      end
      if isLonely then
        local target = neighs[math.random(#neighs)]
        for k = 0, Map.chunksize - 1 do
          for l = 0, Map.chunksize - 1 do
            if Map.Tmap[j+k] and Map.Tmap[j+k][i+l] then
              Map.Tmap[j+k][i+l][1] = target
            end
          end
        end
      end
    end
  end
end

function Map:arrangeChunksBorders()
  for j = 1, Map.chunknumber*Map.chunksize, Map.chunksize do
    for i = 1, Map.chunknumber*Map.chunksize, Map.chunksize do
      local differents = {up = true, down = true, left = true, right = true}
      if Map.Tmap[j-2] and Map.Tmap[j-2][i+1] then
        if  Map.Tmap[j-2][i+1][1]==Map.Tmap[j][i][1] then
          differents.up = false
        end
      end
      if Map.Tmap[j+Map.chunksize] and Map.Tmap[j+Map.chunksize][i] then
        if Map.Tmap[j+Map.chunksize][i][1] == Map.Tmap[j][i][1] then
          differents.down = false
        end
      end
      if Map.Tmap[j+1] and Map.Tmap[j+1][i-2] then
        if Map.Tmap[j+1][i-2][1] == Map.Tmap[j][i][1] then
          differents.left = false
        end
      end
      if Map.Tmap[j] and Map.Tmap[j][i+Map.chunksize] then
        if Map.Tmap[j][i+Map.chunksize][1] == Map.Tmap[j][i][1] then
          differents.right = false
        end
      end
      if differents.up or differents.left or differents.down or differents.right then
        for k = 0, Map.chunksize - 1 do
          for l = 0, Map.chunksize - 1 do
            if Map.Tmap[j+k] and Map.Tmap[j+k][i+l] then
              local old = Map.Tmap[j+k][i+l][1]
              if k==0 and l == 0 then
                if differents.up and differents.left then
                  Map.Tmap[j+k][i+l] = {{x=old.x - 0.5, y = old.y - 0.5}}
                elseif differents.up then
                  Map.Tmap[j+k][i+l] = {{x=old.x, y=old.y - 0.5}}
                elseif differents.left then
                  Map.Tmap[j+k][i+l] = {{x=old.x - 0.5, y=old.y}}
                end
              elseif k==Map.chunksize-1 and l == 0 then
                if differents.down and differents.left then
                  Map.Tmap[j+k][i+l] = {{x=old.x - 0.5, y=old.y + 0.5}}
                elseif differents.down then
                  Map.Tmap[j+k][i+l] = {{x=old.x, y=old.y + 0.5}}
                elseif differents.left then
                  Map.Tmap[j+k][i+l] = {{x=old.x - 0.5, y=old.y}}
                end
              elseif k==0 and l == Map.chunksize-1 then
                if differents.up and differents.right then
                  Map.Tmap[j+k][i+l] = {{x=old.x + 0.5, y=old.y - 0.5}}
                elseif differents.up then
                  Map.Tmap[j+k][i+l] = {{x=old.x, y=old.y - 0.5}}
                elseif differents.right then
                  Map.Tmap[j+k][i+l] = {{x=old.x + 0.5, y=old.y}}
                end
              elseif k== Map.chunksize-1 and l == Map.chunksize-1 then
                if differents.down and differents.right then
                  Map.Tmap[j+k][i+l] = {{x=old.x + 0.5, y=old.y + 0.5}}
                elseif differents.down then
                  Map.Tmap[j+k][i+l] = {{x=old.x, y=old.y + 0.5}}
                elseif differents.right then
                  Map.Tmap[j+k][i+l] = {{x=old.x + 0.5, y=old.y}}
                end
              elseif k==0 then
                if differents.up then
                  Map.Tmap[j+k][i+l] = {{x=old.x, y=old.y - 0.5}}
                end
              elseif k==Map.chunksize-1 then
                if differents.down then
                  Map.Tmap[j+k][i+l] = {{x=old.x, y=old.y + 0.5}}
                end
              elseif l == 0 then
                if differents.left then
                  Map.Tmap[j+k][i+l] = {{x=old.x - 0.5, y=old.y}}
                end
              elseif l == Map.chunksize-1 then
                if differents.right then
                  Map.Tmap[j+k][i+l] = {{x=old.x + 0.5, y=old.y}}
                end
              end
            end
          end
        end
      end
    end
  end
end

function Map:draw(posCam)
  local fx, fy
  for x = (width/2)%32- posCam.x%32 - 32, width + 32, 32 do
    for y = (height/2)%32- posCam.y%32 -32, height + 32, 32 do
      i = math.floor((x+posCam.x-width/2)/32) + 1
      j = math.floor((y+posCam.y-height/2)/32) + 1
      if Map.Tmap[j] and Map.Tmap[j][i] then
        -- local l = (Map.Tmap[j][i]) % (tileSet:getWidth() / 32)
        -- local c = math.floor( (Map.Tmap[j][i]) / (tileSet:getWidth() / 32))
        -- local currX = l * 32
        -- local currY = c * 32
        for n, v in pairs(Map.Tmap[j][i]) do
          local q = love.graphics.newQuad(v["x"]*32, v["y"]*32, 32, 32, tileSet:getDimensions())
          love.graphics.setColor(255, 255, 255)
          love.graphics.draw(tileSet, q, x ,y)
        end
        if love.keyboard.isDown("g") then
          love.graphics.rectangle("line", x, y, 32, 32)
        end
      else
        love.graphics.setColor(255, 0, 255)
        love.graphics.rectangle("fill", x, y, 32, 32)
      end
    end
  end
end

Map:init()
return Map
