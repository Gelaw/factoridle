local Entity = {}

  function Entity:new(pos,dim,image)
    local entity = {}
    entity.image = nil
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
    entity.name = "defaultname"

    function entity:getName()
      return self.name
    end

    function entity:getImage()
      return self.image
    end

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

    entity.color = {r = 55 + love.math.random() * 200, g = 55 + love.math.random() * 200, b = 55 + love.math.random() * 200}

    function entity:draw(posCam)
      local sx = entity.pos.x - posCam.x + width/2 - entity.dim.width/2
      local sy = entity.pos.y - posCam.y + height/2 - entity.dim.height/2
      if entity.image then
        love.graphics.setColor(255,255,255, (entity.ghost and 100 or 255))
        love.graphics.draw(self:getImage(), sx, sy, 0, 1, 1)
        return
      end
      love.graphics.setColor(entity.color.r,entity.color.g,entity.color.b, (entity.ghost and 100 or 255))
      love.graphics.rectangle("fill", sx, sy, entity.dim.width, entity.dim.height)
    end

    function entity:drawTo(sx, sy)
      if entity.image then
        love.graphics.setColor(255,255,255)
        love.graphics.draw(self:getImage(), sx- entity.dim.width/2, sy- entity.dim.height/2, 0, 1, 1)
        return
      end
      love.graphics.setColor(entity.color.r,entity.color.g,entity.color.b)
      love.graphics.rectangle("fill", sx - entity.dim.width/2, sy- entity.dim.height/2,
        entity.dim.width, entity.dim.height)
    end

    return entity
  end


  local machineinc = 0

  function Entity.newMachine(pos, item)
    local machine = Entity:new(pos)
    function machine:init()
      machine:moveTo(pos.x, pos.y) -- Pour se placer a un endroit libre
      machine.name = "machine"..machineinc
      machine.item = item
      machineinc = machineinc + 1
      machine.inputs = Inventory.new({width = 1, height = 4})
      machine.outputs = Inventory.new({width = 1, height = 4})
      machine.image = item:getImage()
    end


    machine:init()
    return machine
  end
return Entity
