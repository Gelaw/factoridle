local Entity = require "entity"
local Inventory = require "inventory"
local Item = require "item"

local RessourceGenerator = {}

  function RessourceGenerator:new(pos, dataID)
    local ressourceGenerator = Entity:new(pos, {width = RessourceGenerator.data[dataID]["width"], height = RessourceGenerator.data[dataID]["height"]})
    ressourceGenerator.movable = false
    ressourceGenerator.image = Item.image[RessourceGenerator.data[dataID]["generatedID"]]["image"]
    ressourceGenerator.inventories.toolSlot = Inventory.new({width = 1, height = 1})
    ressourceGenerator.inventories.inventory = Inventory.new({width = 5, height = 4})
    ressourceGenerator.inventories.inventory.canPlayerAdd = false
    ressourceGenerator.isGenerating = false
    ressourceGenerator.timer = 0

    function ressourceGenerator:initGeneration()
      if ressourceGenerator.isGenerating == true then
        return
      end
      if RessourceGenerator.data[dataID]["requireTool"] then
        if self.inventories.toolSlot.items[1] == nil then
          return
        end
        if  self.inventories.toolSlot.items[1] == "empty"
        or  self.inventories.toolSlot.items[1]:getType() ~= 4
        or self.inventories.toolSlot.items[1]:getSubtype() ~= RessourceGenerator.data[dataID]["toolTypeID"]  then
          return
        end
      end
      ressourceGenerator.timer = 1
      ressourceGenerator.isGenerating = true
    end

    function ressourceGenerator:update(dt)
      if ressourceGenerator.isGenerating == false then
        return
      end
      ressourceGenerator.timer = ressourceGenerator.timer - dt
      if ressourceGenerator.timer < 0 then
        self:generate()
      end
    end

    function ressourceGenerator:generate()
      ressourceGenerator.inventories.inventory:add(Item.new(RessourceGenerator.data[dataID]["generatedID"], 1))
      ressourceGenerator.isGenerating = false
    end

    function ressourceGenerator:getName()
      return RessourceGenerator.data[dataID]["name"]
    end

    return ressourceGenerator
  end

RessourceGenerator.data = {{id = 1, name = "default", toolTypeID = 1, generatedID = 1,
                              width = 50, height = 50, requireTool = false},
                          {id = 2, name = "forest", toolTypeID = 2, generatedID = 2,
                              width = 50, height = 50, requireTool = false},
                          {id = 3, name = "quarry", toolTypeID = 3, generatedID = 3,
                              width = 50, height = 50, requireTool = false},
                          {id = 4, name = "ironmine", toolTypeID = 3, generatedID = 4,
                              width = 50, height = 50, requireTool = true},
                          {id = 5, name = "coppermine", toolTypeID = 3, generatedID = 5,
                              width = 50, height = 50, requireTool = true}}

return RessourceGenerator
