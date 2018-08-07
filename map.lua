local tileSet = love.graphics.newImage("sprite/tileset/tileSet_1.png")

local Map = {}

orientations = {
  center  = {{x=1, y=3}, {x=2, y=3}, {x=1, y=4}, {x=2, y=4}},
  left =    {{x=0, y=3}, {x=0, y=4}},
  right =   {{x=3, y=3}, {x=3, y=4}},
  up =      {{x=1 ,y=2}, {x=2, y=2}},
  down =    {{x=1 ,y=5}, {x=2, y=5}},
  upleftcorner = {{x=0, y=2}},
  uprightcorner = {{x=1, y=0}},
  downleftcorner ={{x=0, y=1}},
  downrightcorner = {{x=1, y=1}},
  upleftinwardcorner = {{x=2, y=0}},
  uprightinwardcorner= {{x=3, y=0}},
  downleftinwardcorner={{x=2, y=1}},
  downrightinwardcorner={{x=3, y=1}}
}


  positionmatches = {
    XXXVVVVVV = "up",
    VXXVVVVVV = "up",
    XXVVVVVVV = "up",
    VVVVVVXXX = "down",
    VVVVVVVXX = "down",
    VVVVVVXXV = "down",
    XVVXVVXVV = "left",
    VVVXVVXVV = "left",
    XVVXVVVVV = "left",
    VVXVVXVVX = "right",
    VVVVVXVVX = "right",
    VVXVVXVVV = "right",
    XXXXVVXVV = "upleftcorner",
    VXXXVVXVV = "upleftcorner",
    VXVXVVXVV = "upleftcorner",
    VXXXVVVVV = "upleftcorner",
    VXVXVVVVV = "upleftcorner",
    XXVXVVXVV = "upleftcorner",
    XXXXVVVVV = "upleftcorner",
    XXXVVXVVX = "uprightcorner",
    XXXVVXVVV = "uprightcorner",
    XXVVVXVVX = "uprightcorner",
    VXXVVXVVX = "uprightcorner",
    XVVXVVXXX = "downleftcorner",
    XVVXVVVXX = "downleftcorner",
    XVVXVVXXV = "downleftcorner",
    VVXVVXXXX = "downrightcorner",
    VVXVVXXXV = "downrightcorner",
    VVXVVXVXX = "downrightcorner",
    VVVVVXXXX = "downrightcorner",
    XVVVVVVVV = "upleftinwardcorner",
    VVXVVVVVV = "uprightinwardcorner",
    VVVVVVXVV = "downleftinwardcorner",
    VVVVVVVVX = "downrightinwardcorner"
  }

grounds = {
  {name = "grass",
  orientation = {x=0, y=0}
    },
  {name = "rock",
  orientation = {x=0, y=6},
  },
  {name = "sand",
  orientation = {x=8, y=6},
  }
}

fioritures = {
  {name = "tree", orientation = {x=16, y=0}, priority = 5, matches = {"grass"}},
  {name = "pine", orientation = {x=20, y=0}, priority = 5, matches = {"grass"}},
  {name = "tallgrass", orientation = {x=12, y=0}, priority = 10, matches = {"grass"}},
  {name = "hill", orientation = {x=24, y=0}, priority = 5, matches = {"grass"}},
  {name = "hole", orientation = {x=20, y=18}, priority = 5, matches = {"sand", "rock"}},
  {name = "sandhill", orientation = {x=24, y=6}, priority = 5, matches = {"sand"}}
}

function Map:init()
  Map.seed = 532100
  Map.chunksize = 32
  Map.chunknumber = 12
  loading = "generating chunks"
end

function Map:load()
  if loading == "generating chunks" then
    self:generateChunks()
    loading = "cleanning small chunks"
  elseif loading == "cleanning small chunks" then
    self:cleanSmallchunks()
    loading = "generating map"
  elseif loading =="generating map" then
    self:generateMap()
    loading = "adding elements"
  elseif loading =="adding elements" then
    self:generateFioriture()
    loading = "done"
  end
end

function Map:generateChunks()
  math.randomseed(Map.seed)
  chunks = {}
  for j = 1, Map.chunknumber, 1 do
    chunks[j] = {}
    for i = 1, Map.chunknumber, 1 do
      if chunks[j-1] and chunks[j-1][i] and chunks[j][i-1] then
        if chunks[j-1][i] == chunks[j][i-1] and math.random() < 0.7 then
          chunks[j][i] = chunks[j-1][i]
        elseif math.random() < 0.75 then
          if math.random() < 0.5 then
            chunks[j][i] = chunks[j-1][i]
          else
            chunks[j][i] = chunks[j][i-1]
          end
        end
      elseif chunks[j-1] and chunks[j-1][i] and math.random() < 0.75 then
        chunks[j][i] = chunks[j-1][i]
      elseif chunks[j][i-1] and math.random() < 0.75 then
        chunks[j][i] = chunks[j][i-1]
      end
      if not chunks[j][i] then
        chunks[j][i] = grounds[math.random(#grounds)].name
      end
    end
  end
end

function Map:generateMap()
    math.randomseed(Map.seed)
  map = {}
  for j = 1, Map.chunknumber*Map.chunksize, 1 do
    map[j] = {}
    for i = 1, Map.chunknumber*Map.chunksize, 1 do
      map[j][i] = {}
      map[j][i].type = chunks[math.ceil(j/Map.chunksize)][math.ceil(i/Map.chunksize)]
      match = ""
      for k = j-1, j+1 do
        for l = i-1, i+1 do
          if chunks[math.ceil((k)/Map.chunksize)] and chunks[math.ceil((k)/Map.chunksize)][math.ceil((l)/Map.chunksize)] and chunks[math.ceil((k)/Map.chunksize)][math.ceil((l)/Map.chunksize)] == map[j][i].type then
            match = match.."V"
          else
            match = match.."X"
          end
        end
      end
      if positionmatches[match] then
        map[j][i].position = positionmatches[match]
      else
        map[j][i].position = "center"
      end
      for _, ground in pairs(grounds) do
        if map[j][i].type == ground.name then
          map[j][i].var = math.floor(math.random(1, #orientations[map[j][i].position]))
        end
      end
      if not map[j][i].var then
        map[j][i].var = 1
      end
      map[j][i].fioritures = {}
    end
  end
end

function Map:cleanSmallchunks()
  math.randomseed(Map.seed)
  for j = 1, Map.chunknumber do
    for i = 1, Map.chunknumber do
      local isLonely = true
      local neighs = {}
      if chunks[j-1] and chunks[j-1][i] then
        table.insert(neighs, chunks[j-1][i])
        if chunks[j-1][i]==chunks[j][i] then
          isLonely = false
        end
      end
      if chunks[j+1] and chunks[j+1][i] then
        table.insert(neighs, chunks[j+1][i])
        if chunks[j+1][i]==chunks[j][i] then
          isLonely = false
        end
      end
      if chunks[j][i-1] then
        table.insert(neighs,chunks[j][i-1])
        if chunks[j][i-1]==chunks[j][i] then
          isLonely = false
        end
      end
      if chunks[j][i+1] then
        table.insert(neighs,chunks[j][i+1])
        if chunks[j][i+Map.chunksize]==chunks[j][i] then
          isLonely = false
        end
      end
      if isLonely then
        chunks[j][i] = neighs[math.random(#neighs)]
      end
    end
  end
end

function Map:generateFioriture()
    math.randomseed(Map.seed)
  function sortFioriture(f1, f2)
    local s1, s2 = 0, 0
    for _, f in pairs(fioritures) do
      if (f1.type == f.name) then
        s1 = f.priority
      end
      if f2.type == f.name then
        s2 = f.priority
      end
    end
    return s1 > s2
  end
  local number = math.random(200, 500)
  n = 1
  while n < number do
    local y = math.random(1, #map)
    local x = math.random(1, #map[y])
    local ysize = math.random(3, 7)
    local xsize = math.random(3, 7)
    local middleType = map[y][x].type
    local fioriture = fioritures[math.random(1, #fioritures)]
    local ok = false
    for _, m in pairs(fioriture.matches) do
      if m == middleType then ok = true end
    end
    if ok then
      n = n + 1
      for j = y - ysize + 1 , y + ysize do
        for i = x - xsize + 1, x + xsize do
          if map[j] and map[j][i] and map[j][i].type == middleType then
            local ok = true
            for _, f in pairs(map[j][i].fioritures) do
              if f.priority == fioriture.priority then ok = false end
            end
            if ok then
              table.insert(map[j][i].fioritures, {type=fioriture.name})
              table.sort(map[j][i].fioritures,  sortFioriture)
            end
          end
        end
      end
    end
  end
  for j = 1, Map.chunknumber*Map.chunksize do
    for i = 1, Map.chunknumber*Map.chunksize do
      for _, fioriture in pairs(map[j][i].fioritures) do
        match =""
        for k = j-1, j+1 do
          for l = i-1, i+1 do
            local V = false
            if map[k] and map[k][l] then
              for _, f in pairs(map[k][l].fioritures) do
                if f.type == fioriture.type then
                  V = true
                end
              end
            end
            if V then
              match = match.."V"
            else
              match = match.."X"
            end
          end
        end
        if positionmatches[match] then
          fioriture.position = positionmatches[match]
        else
          fioriture.position = "center"
        end
        fioriture.var = (j+i)%2 + ((fioriture.position== "up" or fioriture.position== "left") and 2 or 1)
        if (fioriture.var == nil) or (orientations[fioriture.position][fioriture.var] == nil) then
          fioriture.var = 1
        end
      end
    end
  end
end

function Map:draw(posCam)
  local fx, fy
  for x = (width/2)%16- posCam.x%16 - 16, width + 16, 16 do
    for y = (height/2)%16- posCam.y%16-16, height + 16, 16 do
      i = math.floor((x+posCam.x-width/2)/16) + 1
      j = math.floor((y+posCam.y-height/2)/16) + 1
      if map[j] and map[j][i] then
        for _, ground in pairs(grounds) do
          if ground.name == map[j][i].type then
            local q = love.graphics.newQuad((orientations[map[j][i].position][map[j][i].var].x+ground.orientation.x)*16, (orientations[map[j][i].position][map[j][i].var].y+ground.orientation.y)*16, 16, 16, tileSet:getDimensions())
            love.graphics.setColor(255, 255, 255)
            love.graphics.draw(tileSet, q, x ,y)
          end
        end
        for _, fiori in pairs(map[j][i].fioritures) do
          if fiori.position and fiori.var then
            for _, fioriture in pairs(fioritures) do
              if fiori.type == fioriture.name then
                local q = love.graphics.newQuad(
                (orientations[fiori.position][fiori.var].x
                +fioriture.orientation.x)*16,
                (orientations[fiori.position][fiori.var].y
                +fioriture.orientation.y)*16,
                16, 16, tileSet:getDimensions())
                love.graphics.setColor(255, 255, 255)
                love.graphics.draw(tileSet, q, x ,y)
              end
            end
          end
        end
        if love.keyboard.isDown("g") then
          love.graphics.rectangle("line", x, y, 16, 16)
        end
      else
        love.graphics.setColor(255, 0, 255)
        love.graphics.rectangle("fill", x, y, 16, 16)
      end
    end
  end
end

return Map
