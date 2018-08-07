local Inventory = require "inventory"
local Item = require "item"
local Recipe = require "recipe"
local Entity = {}

  function Entity:new(pos,dim,image)
    local entity = {}
    entity.image = nil
    entity.pos = (pos and pos or {x=0, y=0})
    entity.dim = (dim and dim or {width=50, height=50})
    entity.movable = true
    entity.ghost = false
    entity.name = "defaultname"
    entity.inventories = {}

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
      x = x - x % 50 + (x%50>25 and 50 or 0)
      y = y - y % 50 + (y%50>25 and 50 or 0)
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

    entity.color = {r = 255, g =255, b = 255, a = 50}

    function entity:draw(posCam)
      local sx = entity.pos.x - posCam.x + width/2 - entity.dim.width/2
      local sy = entity.pos.y - posCam.y + height/2 - entity.dim.height/2
      love.graphics.setColor(entity.color.r,entity.color.g,entity.color.b, entity.color.a)
      love.graphics.rectangle("fill", sx, sy, entity.dim.width, entity.dim.height)
      if entity.image then
        love.graphics.setColor(255,255,255, (entity.ghost and 100 or 255))
        if self.quad then
          love.graphics.draw(self:getImage(), self.quad, sx, sy)
        else
          love.graphics.draw(self:getImage(), sx, sy)
        end
      end
    end

    function entity:drawTo(sx, sy)
      love.graphics.setColor(entity.color.r,entity.color.g,entity.color.b)
      love.graphics.rectangle("fill", sx - entity.dim.width/2, sy- entity.dim.height/2,
        entity.dim.width, entity.dim.height)
      if entity.image then
        love.graphics.setColor(255,255,255)
        if self.quad then
          love.graphics.draw(self:getImage(), self.quad, sx - entity.dim.width/2, sy- entity.dim.height/2)
        else
          love.graphics.draw(self:getImage(), sx - entity.dim.width/2, sy - entity.dim.height/2)
        end
      end
    end

    function entity:doesntHave(inventory)
      for n, v in pairs(self.inventories) do
        if v == inventory then
          return false
        end
      end
      return true
    end

    function entity:isEmpty()
      for n, v in pairs(self.inventories) do
        if not v:isEmpty() then
          return false
        end
      end
      return true
    end

    return entity
  end


  local machineinc = 0

  function Entity.newMachine(pos, item)
    local machine = Entity:new(pos)

    function machine:init()
      self:moveTo(pos.x, pos.y) -- Pour se placer a un endroit libre
      self.name = "machine"..machineinc
      self.item = item
      machineinc = machineinc + 1
      self.inventories.inputs = Inventory.new({width = 1, height = 4})
      if item:getData().fueltype == "item" then
        self.inventories.fuel = Inventory.new({width = 1, height = 1})
      end
      self.fuelTimer = 0
      self.fuelTimerBase = 0
      self.inventories.outputs = Inventory.new({width = 1, height = 4})
      self.inventories.outputs.canPlayerAdd = false
      self.image = item:getImage()
      self.animImage = item:getAnimImage()
      self.isCrafting = false
    end

    function machine:update(dt)
      if self.fuelTimer > 0 then
        self.fuelTimer = self.fuelTimer - dt
      end
      if self.isCrafting == false then

        local recipes = Recipe.getRecipes(item:getSubtype())
        for r, recipe in pairs(recipes) do
          local ok = true
          for i, intrant in pairs(recipe.intrants) do
            if not machine.inventories.inputs:doesContain(intrant.itemID, intrant.quantity) then
              ok = false
            end
          end
          if ok then
            if self.fuelTimer <= 0 then
              self:refuel()
              if self.fuelTimer <= 0 then return end
            end
            for i, intrant in pairs(recipe.intrants) do
              machine.inventories.inputs:removeQuantityOf(intrant.itemID, intrant.quantity)
            end
            self.isCrafting = true
            self.timer = recipe.time
            self.extrants = recipe.extrants
            self:turnAnimOn()
            return
          end
        end
      else
        if self.fuelTimer <= 0 then
          self:refuel()
          if self.fuelTimer <= 0 then return end
        end
        self:updateAnim(dt)
        self.timer = self.timer - dt
        if self.timer <= 0 then
          self.isCrafting = false
          self:turnAnimOff()
          self.timer = nil
          for i, extrant in pairs(self.extrants) do
            print(extrant.itemID, extrant.quantity)
            machine.inventories.outputs:add(Item.new(extrant.itemID, extrant.quantity))
          end
          self.extrants = nil
        end
      end
    end

    function machine:addFuel(tf)
      self.fuelTimer = tf
      self.fuelTimerBase = tf
    end

    function machine:refuel()
      if self.fuelTimer <= 0 then
        if item:getData().fueltype == "item" then
          for _, fuel in pairs(item:getData().fuel) do
            if self.inventories.fuel:doesContain(fuel.id, 1) then
              self.inventories.fuel:removeQuantityOf(fuel.id, 1)
              self:addFuel(fuel.time)
            end
          end
        end
      end
    end

    function machine:turnAnimOn()
      if self.animImage then
        self.animFrame = 1
        self.animTimer = 0.5
        self.image = self.animImage
        self.quad =  love.graphics.newQuad(50*self.animFrame,0, 50, 50, self.animImage:getDimensions())
      end
    end

    function machine:turnAnimOff()
      if self.animImage then
        self.image = item:getImage()
        self.animFrame = nil
        self.animTimer = nil
        self.quad = nil
      end
    end

    function machine:updateAnim(dt)
      if self.animImage and self.animTimer then
        self.animTimer = self.animTimer - dt
        if self.animTimer < 0 then
          self.animFrame = (self.animFrame + 1) %  (self.animImage:getWidth()/50) + 1
          self.animTimer = 0.5
          self.quad =  love.graphics.newQuad(50*self.animFrame,0, 50, 50, self.animImage:getWidth(), self.animImage:getHeight())
        end
      end
    end

    machine:init()
    return machine
  end
return Entity
