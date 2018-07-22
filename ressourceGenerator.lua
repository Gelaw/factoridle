local Entity = require "entity"
local Inventory = require "inventory"
local Item = require "item"

local RessourceGenerator = {}

  function RessourceGenerator:new(pos, dataID)
    local ressourceGenerator = Entity:new(pos, {width = RessourceGenerator.data[dataID]["width"], height = RessourceGenerator.data[dataID]["height"]})
    ressourceGenerator.movable = false

    ressourceGenerator.toolSlot = Inventory:new({width = 1, height = 1})
    ressourceGenerator.inventory = Inventory:new({width = 5, height = 4})
    ressourceGenerator.isGenerating = false
    ressourceGenerator.timer = 0

    function ressourceGenerator:initGeneration()
      if ressourceGenerator.isGenerating == true then
        return
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
      ressourceGenerator.inventory:add(Item:new(RessourceGenerator.data[dataID]["generatedID"], 1))
      ressourceGenerator.isGenerating = false
    end

    return ressourceGenerator
  end

RessourceGenerator.data = {{id = 1, name = "default", toolTypeID = 1, generatedID = 1,
                              width = 50, height = 50},
                          {id = 2, name = "forest", toolTypeID = 2, generatedID = 2,
                              width = 50, height = 50},
                          {id = 3, name = "quarry", toolTypeID = 3, generatedID = 3,
                              width = 50, height = 50}}

return RessourceGenerator
