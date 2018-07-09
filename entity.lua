local Entity = {}

  function Entity:new()
    local entity = {}
    entity.image = {}
    entity.pos = {x = 0, y = 0}
    entity.dim = {width = 20, height = 20}

    function entity:init(pos,image,dim)
      entity.pos = pos
      if image then
        entity.image = image
      end
      if dim then
        entity.dim = dim
      end
    end

    function entity:move(dx, dy)
      entity.pos.x = entity.pos.x + dx
      entity.pos.y = entity.pos.y + dy
    end

    function entity:doesTouch(x, y)
      if x > entity.pos.x - entity.dim.width / 2
      and x < entity.pos.x + entity.dim.width / 2
      and y > entity.pos.y - entity.dim.height / 2
      and y < entity.pos.y + entity.dim.height / 2 then
        return true
      end
      return false
    end

    function entity:draw(posCam)
      --[[
      love.graphics.draw(
        entity.image,
        entity.pos.x - posCam.x + width/2,
        entity.pos.y - posCam.y + height/2,
        0, 1, 1)]]

        love.graphics.setColor(100 + love.math.random() * 155,100 + love.math.random() * 155,100+ love.math.random() * 155)
        love.graphics.rectangle("fill",
          entity.pos.x - posCam.x + width/2 - entity.dim.width/2,
          entity.pos.y - posCam.y + height/2 - entity.dim.height/2,
          entity.dim.width, entity.dim.height)
    end
    return entity
  end

return Entity
