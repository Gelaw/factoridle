local Entity = require "entity"
local Item = {}

function Item:new(dataID, quantity)
  local item = {}
  item.dataID = dataID
  item.quantity = quantity


  function item:getName()
    return Item.data[item.dataID]["name"]
  end

  function item:getType()
    return Item.data[item.dataID]["type"]
  end

  function item:getSubtype()
    return Item.data[item.dataID]["subtype"]
  end

  function item:getLimit()
    return Item.data[item.dataID]["limit"]
  end

  function item:dropOnWorld(pos)
    if item.isMachine and item.entity == nil then
      item.entity = Entity:newMachine(pos)
      item.entity.item = item
      world:addEntity(item.entity)
    end
    return item.entity
  end

  function item:dragOnInventory()
    if item.isMachine and item.entity then
      world:removeEntity(item.entity)
      item.entity = nil
    end
  end

  if item:getType() == 3 then
    item.isMachine = true
  end

  return item
end

Item.data = {{id = 1, name = "default", type = 1, limit = 100},
            {id = 2, name = "wood", type = 2, limit = 100},
            {id = 3, name = "stone", type = 2, limit = 100},
            {id = 4, name = "iron ore", type = 2, limit = 100},
            {id = 5, name = "copper ore", type = 2, limit = 100},
            {id = 6, name = "iron ingot", type = 2, limit = 100},
            {id = 7, name = "copper ingot", type = 2, limit = 100},
            {id = 8, name = "stone brick", type = 2, limit = 100},
            {id = 9, name = "stone furnace", type = 3, subtype = 2, limit = 20},
            {id = 10, name = "stone pickaxe", type = 4, subtype = 3, limit = 100}}

local typeData = {{id = 1, name = "default"},
                  {id = 2, name = "ressource"},
                  {id = 3, name = "machine"},
                  {id = 4, name = "tool"}}

local machineSubtypeData = {{id = 1, type = "default"},
                            {id = 2, type = "furnace"},
                            {id = 3, type = "press"}}

local toolSubtypeData = {{id = 1, type = "default"},
                        {id = 2, type = "axe"},
                        {id = 3, type = "pickaxe"}}
return Item
