local RessourceMaker = {}

  function RessourceMaker:new()
    local ressourceMaker = {}
    ressourceMaker.image = {}
    ressourceMaker.pos = {x = 0, y = 0}
    ressourceMaker.dim = {width = 20, height = 20}

    function ressourceMaker:init(pos,image,dim)
      ressourceMaker.pos = pos
      if image then
        ressourceMaker.image = image
      end
      if dim then
        ressourceMaker.dim = dim
      end
    end

    function ressourceMaker:move(dx, dy)
      ressourceMaker.pos.x = ressourceMaker.pos.x + dx
      ressourceMaker.pos.y = ressourceMaker.pos.y + dy
    end

    function ressourceMaker:doesTouch(x, y)
      if x > ressourceMaker.pos.x - ressourceMaker.dim.width / 2
      and x < ressourceMaker.pos.x + ressourceMaker.dim.width / 2
      and y > ressourceMaker.pos.y - ressourceMaker.dim.height / 2
      and y < ressourceMaker.pos.y + ressourceMaker.dim.height / 2 then
        return true
      end
      return false
    end

    function ressourceMaker:draw(posCam)
      --[[
      love.graphics.draw(
        ressourceMaker.image,
        ressourceMaker.pos.x - posCam.x + width/2,
        ressourceMaker.pos.y - posCam.y + height/2,
        0, 1, 1)]]

        love.graphics.setColor(255, 25, 50)
        love.graphics.rectangle("fill",
          ressourceMaker.pos.x - posCam.x + width/2 - ressourceMaker.dim.width/2,
          ressourceMaker.pos.y - posCam.y + height/2 - ressourceMaker.dim.height/2,
          ressourceMaker.dim.width, ressourceMaker.dim.height)
    end
    return ressourceMaker
  end

return RessourceMaker
