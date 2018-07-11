local Entity = require "entity"
local Inventory = require "inventory"
local Item = require "item"

local World = {}

  function World:new()
    world = {}
    world.entities = {}

    function world:init()
      world.entities[1] = Entity:new()
      world.entities[1]:init({x = 200, y = 200})

      world.entities[2] = Entity:new()
      world.entities[2]:init({x = 300, y = 200})

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
      for e  = 1, #world.entities, 1 do
        world.entities[e]:draw(posCam)
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


    function world:testmove(entity, dx, dy)
      for e  = 1, #world.entities, 1 do
        if entity ~= world.entities[e]
          and (world.entities[e]:doesTouch(entity.pos.x + dx - entity.dim.width / 2 + 1, entity.pos.y + dy - entity.dim.height / 2 + 1)
            or world.entities[e]:doesTouch(entity.pos.x + dx + entity.dim.width / 2 - 1, entity.pos.y + dy + entity.dim.height / 2 - 1)
            or world.entities[e]:doesTouch(entity.pos.x + dx + entity.dim.width / 2 - 1, entity.pos.y + dy - entity.dim.height / 2 + 1)
            or world.entities[e]:doesTouch(entity.pos.x + dx - entity.dim.width / 2 + 1, entity.pos.y + dy + entity.dim.height / 2 - 1)) then
            return false
        end
      end
      entity:move(dx, dy)
      return true
    end

    function world:isFree(x, y, entity)
      for e  = 1, #world.entities, 1 do
        if entity ~= world.entities[e] and world.entities[e]:doesTouch(x, y) then
          return false
        end
      end
      return true
    end

    return world
  end

return World
