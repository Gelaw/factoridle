local Inventory = require "inventory"
local Item = require "item"
local Recipe = require "recipe"
local Entity = {}

  function Entity:new(pos,dim,image)
    local entity = {}
    entity.image = nil
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
      if x %50 < 25 then
        x = x - x %50
      else
        x = x-  x %50 + 50
      end
      if y %50 < 25 then
        y = y -y %50
      else
        y = y - y %50 + 50
      end
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

    entity.color = {r = 55 + love.math.random() * 200, g = 55 + love.math.random() * 200, b = 55 + love.math.random() * 200}

    function entity:draw(posCam)
      local sx = entity.pos.x - posCam.x + width/2 - entity.dim.width/2
      local sy = entity.pos.y - posCam.y + height/2 - entity.dim.height/2
      if entity.image then
        love.graphics.setColor(255,255,255, (entity.ghost and 100 or 255))
        if self.quad then
          love.graphics.draw(self:getImage(), self.quad, sx, sy)
        else
          love.graphics.draw(self:getImage(), sx, sy)
        end
        return
      end
      love.graphics.setColor(entity.color.r,entity.color.g,entity.color.b, (entity.ghost and 100 or 255))
      love.graphics.rectangle("fill", sx, sy, entity.dim.width, entity.dim.height)
    end

    function entity:drawTo(sx, sy)
      if entity.image then
        love.graphics.setColor(255,255,255)
        love.graphics.draw(self:getImage(), sx- entity.dim.width/2, sy- entity.dim.height/2, 0, 1, 1)
        return
      end
      love.graphics.setColor(entity.color.r,entity.color.g,entity.color.b)
      love.graphics.rectangle("fill", sx - entity.dim.width/2, sy- entity.dim.height/2,
        entity.dim.width, entity.dim.height)
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
      self.inventories.outputs = Inventory.new({width = 1, height = 4})
      self.inventories.outputs.canPlayerAdd = false
      self.image = item:getImage()
      self.animImage = item:getAnimImage()
      self.isCrafting = false
    end

    function machine:update(dt)
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
            for i, intrant in pairs(recipe.intrants) do
              machine.inventories.inputs:removeQuantityOf(intrant.itemID, intrant.quantity)
            end
            self.isCrafting = true
            self.timer = recipe.time
            self.animFrame = 1
            self.animTimer = 0.5
            self.image = self.animImage
            self.quad =  love.graphics.newQuad(50*self.animFrame,0, 50, 50, self.animImage:getDimensions())
            self.extrants = recipe.extrants
            return
          end
        end
      else
        self.animTimer = self.animTimer - dt
        if self.animTimer < 0 then
          self.animFrame = (self.animFrame + 1) %  (self.animImage:getWidth()/50) + 1
          self.animTimer = 0.5
          self.quad =  love.graphics.newQuad(50*self.animFrame,0, 50, 50, self.animImage:getWidth(), self.animImage:getHeight())
        end
        self.timer = self.timer - dt
        if self.timer <= 0 then
          self.isCrafting = false
          self.image = item:getImage()
          self.animFrame = nil
          self.animTimer = nil
          self.quad = nil
          self.timer = nil
          for i, extrant in pairs(self.extrants) do
            print(extrant.itemID, extrant.quantity)
            machine.inventories.outputs:add(Item.new(extrant.itemID, extrant.quantity))
          end
          self.extrants = nil
        end
      end
    end

    machine:init()
    return machine
  end
return Entity
