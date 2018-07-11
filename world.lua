local Entity = require "entity"
local Inventory = require "inventory"
local Item = require "item"

local World = {}

  function World:new()
    world = {}
    world.entities = {}

    function world:init()
      world.entities[1] = Entity:new()
      world.entities[1]:init({x = 200, y = 250})

      world.entities[2] = Entity:new()
      world.entities[2]:init({x = 300, y = 250})

      world.entities[3] = Entity:new()
      world.entities[3]:init({x = 150, y = 350})

      world.entities[4] = Entity:new()
      world.entities[4]:init({x = 200, y = 400})

      world.entities[5] = Entity:new()
      world.entities[5]:init({x = 250, y = 400})

      world.entities[6] = Entity:new()
      world.entities[6]:init({x = 300, y = 400})

      world.entities[7] = Entity:new()
      world.entities[7]:init({x = 350, y = 350})

      inventory = Inventory:new()
      inventory:init(20)
    end

    function world:draw(posCam)
      for i, entity in pairs(world.entities) do
        entity:draw(posCam)
      end
    end

    timer = 0
    function world:update(dt)
      timer = timer + dt
      if timer > 1 then
        timer = 0
        item = Item:new()
        local idtype = math.floor((#Item.stereotypes - 1) * love.math.random() + 2)
        item:init(idtype, 1)
        inventory:add(item)
      end
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
