local Inventory = require "inventory"
local Item = require "item"
local Recipe = require "recipe"

Player = {}

function Player.new()
  local player = {}

  function player:init()
    self.inventory = Inventory.new({width = 7, height = 4})
    self.recipes = Recipe.getRecipes("player")
    self.isCrafting = false
  end

  function player:update(dt)
    if self.isCrafting == true then
      self.timer = self.timer - dt
      if self.timer <= 0 then
        print("?")
        self.isCrafting = false
        self.timer = nil
        for i, extrant in pairs(self.extrants) do
          self.inventory:add(Item.new(extrant.itemID, extrant.quantity))
        end
        self.extrants = nil
      end
    end
  end

  function player:craft(recipe)
    if self.isCrafting == false then
      local ok = true
      for i, intrant in pairs(recipe.intrants) do
        if not self.inventory:doesContain(intrant.itemID, intrant.quantity) then
          ok = false
        end
      end
      if ok then
        for i, intrant in pairs(recipe.intrants) do
          self.inventory:removeQuantityOf(intrant.itemID, intrant.quantity)
        end
        self.isCrafting = true
        self.timer = recipe.time
        self.extrants = recipe.extrants
        return
      end
    end
  end

  player:init()
  return player
end

return Player
