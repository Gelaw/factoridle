local Entity = require "entity"
local Inventory = require "inventory"
local Item = require "item"
local RessourceGenerator = require "ressourceGenerator"

local World = {}

  function World:new()
    local world = {}
    world.entities = {}
    world.inventory = Inventory:new(20)
    world.posCam = {x = 0, y = 0}
    local forest = RessourceGenerator:new({x = 50, y = 50}, 2)
    table.insert(world.entities, forest)

    function world:draw()
      love.graphics.setColor(25, 25, 25)
      for x = - world.posCam.x%50 - 50 ,  width + 50, 50 do
        for y = - world.posCam.y%50 - 50,  height + 50, 50 do
          love.graphics.rectangle("fill", x -24 , y -24 , 48, 48)
        end
      end
      for i, entity in pairs(world.entities) do
        entity:draw(world.posCam)
      end
      if world.handledEntity ~= nil then
        world.handledEntity:draw(world.posCam)
      end
      love.graphics.setColor(255,255,255)
      love.graphics.print(forest.inventory:prompt(), 30, height / 2)
      love.graphics.print("cam: x:" ..world.posCam.x.." y:"..world.posCam.y, 30, 30)
      love.graphics.print("mouse: x:" .. love.mouse.getX() - width/2 + world.posCam.x   .. " y:" ..love.mouse.getY() -height/2 + world.posCam.y, 30, 50)
      love.graphics.line(width/2, height/2 - 10, width/2, height/2 + 10)
      love.graphics.line(width/2 - 10, height/2, width/2 + 10, height/2)
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
      for i, entity in pairs(world.entities) do
        if entity:doesTouch(x - width/2 + world.posCam.x, y - height/2 + world.posCam.y) then
          if world.handledEntity == nil then
            world.handledEntity = entity
            return
          end
        end
      end
    end

    function world:mousereleased()
      if world.handledEntity and world.handledEntity.pos then
        x, y = 0, 0
        if world.handledEntity.pos.x %50 < 25 then
          x = world.handledEntity.pos.x - world.handledEntity.pos.x %50
        else
          x = world.handledEntity.pos.x - world.handledEntity.pos.x %50 + 50
        end
        if world.handledEntity.pos.y %50 < 25 then
          y = world.handledEntity.pos.y - world.handledEntity.pos.y %50
        else
          y = world.handledEntity.pos.y - world.handledEntity.pos.y %50 + 50
        end
        isfree = world:isFree(x, y, world.handledEntity)
        while isfree==false do
          x  = x + 50
          isfree = world:isFree(x, y, world.handledEntity)
        end
        world.handledEntity.pos.x = x
        world.handledEntity.pos.y = y
        world.handledEntity = nil
      end
    end

    function world:mousemoved(x, y, dx, dy)
      if love.mouse.isDown(1) then
        if world.handledEntity and world.handledEntity.move then
          world.handledEntity:move(dx, dy)
        else
          world.posCam.x = world.posCam.x - dx
          world.posCam.y = world.posCam.y - dy
        end
      end
    end

    return world
  end

return World
