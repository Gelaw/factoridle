local Item = {}

function Item:new(dataID, quantity)
  local item = {}
  item.dataID = dataID
  item.quantity = quantity

  function item:getName()
    return Item.data[item.dataID]["name"]
  end

  return item
end

Item.data = {{id = 1, name = "default", type = 1},
            {id = 2, name = "wood", type = 2},
            {id = 3, name = "stone", type = 2},
            {id = 4, name = "iron ore", type = 2},
            {id = 5, name = "copper ore", type = 2},
            {id = 6, name = "iron ingot", type = 2},
            {id = 7, name = "copper ingot", type = 2},
            {id = 8, name = "stone brick", type = 2},
            {id = 9, name = "stone furnace", type = 3, subtype = 2},
            {id = 10, name = "stone pickaxe", type = 4, subtype = 3}}

Item.itemType = {{id = 1, name = "default"},
                {id = 2, name = "ressource"},
                {id = 3, name = "machine"},
                {id = 4, name = "tool"}}

Item.machineSubtypes = {{id = 1, type = "default"},
                    {id = 2, type = "furnace"},
                    {id = 3, type = "press"}}

Item.toolSubtypes = {{id = 1, type = "default"},
                  {id = 2, type = "axe"},
                  {id = 3, type = "pickaxe"}}
return Item
