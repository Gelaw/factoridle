local Entity = require "entity"
local Player = require "player"
local Map = require "map"
local RessourceGenerator = require "ressourceGenerator"
local map = love.graphics.newImage("sprite/mapT.png")

local World = {}

  function World.new()
    local world = {}

    function world:init()
      self.entities = {}
      Map:init(self.addRG)
      self.player = Player.new()
      self.posCam = { minx = width/2, miny = height/2, maxx = Map.chunknumber*Map.chunksize*16-width/2, maxy = Map.chunknumber*Map.chunksize*16-height/2}
      self.posCam.x, world.posCam.y = world.posCam.minx, world.posCam.miny
      -- local forest = RessourceGenerator:new({x = 20*32, y = 32}, 2)
      -- world:addEntity(forest)
      -- interface:addGroupRG(forest)
      -- local quarry = RessourceGenerator:new({x = 5*32, y = 15*32}, 3)
      -- world:addEntity(quarry)
      -- interface:addGroupRG(quarry)
      -- local ironmine = RessourceGenerator:new({x = 6*32, y = 7*32}, 4)
      -- world:addEntity(ironmine)
      -- interface:addGroupRG(ironmine)
      -- local coppermine = RessourceGenerator:new({x = 10*32, y = 8*32}, 5)
      -- world:addEntity(coppermine)
      -- interface:addGroupRG(coppermine)
    end

    function world:load()
      Map:load()
    end

    function world:addRG(x, y, item)
      local rg = RessourceGenerator:new({x = x, y = y}, item)
      world:addEntity(rg)
      interface:addGroupRG(rg)
    end

    function world:addEntity(entity)
      table.insert(world.entities, entity)
    end

    function world:draw()
    love.graphics.setColor(255, 255, 255)
    Map:draw(world.posCam)
      for i, entity in pairs(world.entities) do
        entity:draw(world.posCam)
      end

      love.graphics.setColor(255,255,255)
      love.graphics.print("cam: x:" ..world.posCam.x.." y:"..world.posCam.y, 30, 30)
      love.graphics.print("mouse: x:" .. love.mouse.getX() - width/2 + world.posCam.x   .. " y:" ..love.mouse.getY() -height/2 + world.posCam.y, 30, 50)
      love.graphics.line(width/2, height/2 - 10, width/2, height/2 + 10)
      love.graphics.line(width/2 - 10, height/2, width/2 + 10, height/2)
      local x =  10
      local y = 200
      for n, v in pairs(grab) do
        if type(v) == "table" then
          for n2, v2 in pairs(v) do
            if type(v2) == "string" or type(v2) == "number" then
              love.graphics.print("grab["..n.."]["..n2.."] = "..v2, x, y)
              y = y + 15
            elseif type(v2) == "boolean" then
              love.graphics.print("grab["..n.."]["..n2.."] = "..(v2 and "true" or "false"), x, y)
              y = y + 15
            elseif type(v2) ~= "function" then
              love.graphics.print("grab["..n.."]["..n2.."]", x, y)
              y = y + 15
            end
          end
        else
          love.graphics.print("grab["..n.."] = " .. v, x, y)
        end
        y = y + 15
      end
    end

    function world:update(dt)
      self.player:update(dt)
      for e, entity in pairs(self.entities) do
        if entity.update then
          entity:update(dt)
        end
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
        for i, entity in pairs(world.entities) do
          if entity:doesTouch(x - width/2 + world.posCam.x, y - height/2 + world.posCam.y) then
            interface:toggle(entity:getName())
          end
        end
      end
    end

    function world:mousereleased(x, y, button, isTouch)
      if grab.status == "entity" then
        grab.entity:moveTo(love.mouse.getX() - width/2 + world.posCam.x, love.mouse.getY() -height/2 + world.posCam.y )
        grab.entity.ghost = false
        return
      end
      if grab.status == "item" and grab.item.isMachine then
        local item = grab.inventory:removeQuantityFrom(grab.slot, 1)
        local machine = Entity.newMachine({x =  x - width/2 + world.posCam.x, y = y -height/2 + world.posCam.y}, item)
        self:addEntity(machine)
        interface:addGroupMachine(machine)
        return
      end
    end

    function world:mousemoved(x, y, dx, dy)
      if love.mouse.isDown(1) then
        if world.handledEntity == nil then
          if world.posCam.x - dx < world.posCam.minx then
            world.posCam.x = world.posCam.minx
          elseif world.posCam.x - dx > world.posCam.maxx then
            world.posCam.x = world.posCam.maxx
          else
            world.posCam.x = world.posCam.x - dx
          end
          if world.posCam.y - dy < world.posCam.miny then
            world.posCam.y = world.posCam.miny
          elseif world.posCam.y - dy > world.posCam.maxy then
            world.posCam.y = world.posCam.maxy
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
          interface:removeGroup(entity:getName())
          return
        end
      end
    end

    function world:resetClick()
      if grab.status == "entity" then
        grab.entity.ghost = false
      end
    end

    world:init()
    return world
  end

return World
