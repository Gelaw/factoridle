local Entity = require "entity"
local Inventory = require "inventory"
local Item = require "item"
local RessourceGenerator = require "ressourceGenerator"

local World = {}

  function World:new()
    world = {}
    world.entities = {}
    inventory = Inventory:new(20)

    forest = RessourceGenerator:new({x = 50, y = 50}, 2)
    table.insert(world.entities, forest)

    function world:draw(posCam)
      love.graphics.setColor(25, 25, 25)
      for x = - posCam.x%50 - 50 ,  width + 50, 50 do
        for y = - posCam.y%50 - 50,  height + 50, 50 do
          love.graphics.rectangle("fill", x -24 , y -24 , 48, 48)
        end
      end
      for i, entity in pairs(world.entities) do
        entity:draw(posCam)
      end
      love.graphics.setColor(255,255,255)
      love.graphics.print(forest.inventory:prompt(), 30, height / 2)
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

    return world
  end

return World
