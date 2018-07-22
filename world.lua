local Entity = require "entity"
local Inventory = require "inventory"
local Item = require "item"
local RessourceGenerator = require "ressourceGenerator"

local World = {}

  function World:new()
    local world = {}
    world.entities = {}
    world.inventory = Inventory:new({width = 5, height = 4})
    world.inventory:add(Item:new(9, 100))
    world.inventory:add(Item:new(7, 100))
    world.inventory:add(Item:new(6, 100))
    world.inventory:add(Item:new(4, 100))
    world.inventory:add(Item:new(5, 100))
    world.inventory:add(Item:new(2, 100))
    world.inventory:add(Item:new(3, 100))
    world.posCam = {x = 0, y = 0}

    function world:addEntity(entity)
      table.insert(world.entities, entity)
    end

    local forest = RessourceGenerator:new({x = 50, y = 50}, 2)
    world:addEntity(forest)


    function world:draw()
      love.graphics.setColor(25, 25, 25)
      for x = (width/2)%50- world.posCam.x%50 - 50 ,  width + 50, 50 do
        for y = (height/2)%50- world.posCam.y%50 - 50,  height + 50, 50 do
          love.graphics.rectangle("fill", x - 24  , y - 24 , 48, 48)
        end
      end
      for i, entity in pairs(world.entities) do
        entity:draw(world.posCam)
      end
      love.graphics.setColor(255,255,255)
      love.graphics.print(world.inventory:prompt(), 30, height / 2)
      love.graphics.print("cam: x:" ..world.posCam.x.." y:"..world.posCam.y, 30, 30)
      love.graphics.print("mouse: x:" .. love.mouse.getX() - width/2 + world.posCam.x   .. " y:" ..love.mouse.getY() -height/2 + world.posCam.y, 30, 50)
      love.graphics.line(width/2, height/2 - 10, width/2, height/2 + 10)
      love.graphics.line(width/2 - 10, height/2, width/2 + 10, height/2)
      local x = width - 300
      local y = height - 500
      for n, v in pairs(grab) do
        if (type(v) == "table") then
          love.graphics.print("grab["..n.."] ", x, y)
        else
          love.graphics.print("grab["..n.."] = " .. v, x, y)
        end
        y = y + 30
      end
    end

    function world:update(dt)
      forest:update(dt)
    end

    function world:initTreeGeneration()
      forest:initGeneration()
    end

    function world:testmove(movingEntity, dx, dy)
      for i, entity in pairs(world.entities) do
        local x = movingEntity.pos.x
        local y = movingEntity.pos.y
        local width = movingEntity.dim.width
        local height = movingEntity.dim.height
        if movingEntity ~= entity
          and (entity:doesTouch(x + dx - width / 2 + 1, y + dy - height / 2 + 1)
            or entity:doesTouch(x + dx + width / 2 - 1, y + dy + height / 2 - 1)
            or entity:doesTouch(x + dx + width / 2 - 1, y + dy - height / 2 + 1)
            or entity:doesTouch(x + dx - width / 2 + 1, y + dy + height / 2 - 1)) then
            return false
        end
      end
      movingEntity:move(dx, dy)
      return true
    end

    function world:isFree(x, y, testingEntity)
      for i, entity in pairs(world.entities) do
        if testingEntity ~= entity and entity:doesTouch(x, y) then
          return false
        end
      end
      return true
    end

    function world:mousepressed(x, y, button, isTouch)
      if button == 1 then
        for i, entity in pairs(world.entities) do
          if entity:doesTouch(x - width/2 + world.posCam.x, y - height/2 + world.posCam.y) then
            if grab.status == nil and entity.movable == true then
              grab.status = "entity"
              grab.entity = entity
              entity.ghost = true
              return
            end
          end
        end
      elseif button == 2 then

      end
    end

    function world:mousereleased()
      if grab.status == "entity" then
        grab.entity:moveTo(love.mouse.getX() - width/2 + world.posCam.x, love.mouse.getY() -height/2 + world.posCam.y )
        grab.entity.ghost = false
        return
      end
      if grab.status == "item" and grab.inventory.items[grab.slot].isMachine then
        local machine = grab.inventory:removeQuantityFrom(grab.slot, 1)
        machine:dropOnWorld({x =  love.mouse.getX() - width/2 + world.posCam.x, y = love.mouse.getY() -height/2 + world.posCam.y})
        return
      end
    end

    function world:mousemoved(x, y, dx, dy)
      if love.mouse.isDown(1) then
        if world.handledEntity == nil then
          if world.posCam.x - dx < -5000 then
            world.posCam.x = -5000
          elseif world.posCam.x - dx > 5000 then
            world.posCam.x = 5000
          else
            world.posCam.x = world.posCam.x - dx
          end
          if world.posCam.y - dy < -5000 then
            world.posCam.y = -5000
          elseif world.posCam.y - dy > 5000 then
            world.posCam.y = 5000
          else
            world.posCam.y = world.posCam.y - dy
          end
        end
      end
    end

    function world:removeEntity(entity)
      for e, ent in pairs(world.entities) do
        if entity == ent then
          table.remove(world.entities, e)
          return
        end
      end
    end

    function world:resetClick()
      if grab.status == "entity" then
        grab.entity.ghost = false
      end
    end

    return world
  end

return World
