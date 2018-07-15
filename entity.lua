local Entity = {}

  function Entity:new(pos,dim,image)
    local entity = {}
    entity.image = {}
    if pos then
      entity.pos = pos
    else
      entity.pos = {x = 0, y = 0}
    end
    if dim then
      entity.dim = dim
    else
      entity.dim = {width = 50, height = 50}
    end
    entity.movable = true
    entity.ghost = false

    function entity:move(dx, dy)
      if entity.movable == false then
        return
      end
      entity.pos.x = entity.pos.x + dx
      entity.pos.y = entity.pos.y + dy
    end

    function entity:moveTo(x, y)
      if entity.movable == false then
        return
      end
      if x %50 < 25 then
        x = x - x %50
      else
        x = x-  x %50 + 50
      end
      if y %50 < 25 then
        y = y -y %50
      else
        y = y - y %50 + 50
      end
      closedPos = {}
      openPos = {{x = x, y = y}}
      while true do
        if #openPos == 0 then
          return
        end
        local pos = table.remove(openPos, 1)
        if world:isFree(pos.x, pos.y, entity) then
          entity.pos = pos
          return
        end
        table.insert(closedPos, pos)
        local voisins = {{x = pos.x, y = pos.y + 50}, {x = pos.x - 50, y = pos.y}, {x = pos.x, y = pos.y - 50}, {x = pos.x + 50, y = pos.y}}
        for v, voisin in pairs(voisins) do
          local inClosedPos = false
          for p, position in pairs(closedPos) do
            if voisin.x == position.x and voisin.y == position.y then
              inClosedPos = true
            end
          end
          if inClosedPos == false then
            table.insert(openPos, voisin)
          end
        end
      end
    end

    function entity:doesTouch(x, y)
      local ex = entity.pos.x
      local ey = entity.pos.y
      local ew = entity.dim.width
      local eh = entity.dim.height
      if x > ex - ew / 2
      and x < ex + ew / 2
      and y > ey - eh / 2
      and y < ey + eh / 2 then
        return true
      end
      return false
    end

    entity.r = 55 + love.math.random() * 200
    entity.g = 55 + love.math.random() * 200
    entity.b = 55 + love.math.random() * 200

    function entity:draw(posCam)
      if entity.ghost then
        love.graphics.setColor(entity.r,entity.g,entity.b, 100)
      else
        love.graphics.setColor(entity.r,entity.g,entity.b)
      end

        love.graphics.rectangle("fill",
          entity.pos.x - posCam.x + width/2 - entity.dim.width/2,
          entity.pos.y - posCam.y + height/2 - entity.dim.height/2,
          entity.dim.width, entity.dim.height)
    end

    function entity:drawTo(x, y)
      love.graphics.setColor(entity.r,entity.g,entity.b)
      love.graphics.rectangle("fill", x- entity.dim.width/2, y- entity.dim.height/2,
        entity.dim.width, entity.dim.height)
    end

    return entity
  end



  function Entity:newMachine(pos, machineID)
    local entity = Entity:new(pos)
      entity:moveTo(pos.x, pos.y)
    return entity
  end
return Entity
