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
    print(entity.pos.x, entity.pos.y)
    function entity:move(dx, dy)
      if entity.movable == false then
        return
      end
      entity.pos.x = entity.pos.x + dx
      entity.pos.y = entity.pos.y + dy

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

    entity.r = love.math.random() * 255
    entity.g = love.math.random() * 255
    entity.b = love.math.random() * 255
    function entity:draw(posCam)
      --[[
      love.graphics.draw(
        entity.image,
        entity.pos.x - posCam.x + width/2,
        entity.pos.y - posCam.y + height/2,
        0, 1, 1)]]

        love.graphics.setColor(entity.r,entity.g,entity.b)
        love.graphics.rectangle("fill",
          entity.pos.x - posCam.x + width/2 - entity.dim.width/2,
          entity.pos.y - posCam.y + height/2 - entity.dim.height/2,
          entity.dim.width, entity.dim.height)
    end
    return entity
  end

return Entity
