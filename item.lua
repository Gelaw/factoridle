local Item = {}

function Item.new(dataID, quantity)
  local item = {}
  item.dataID = dataID
  item.quantity = quantity


  function item:getName()
    return Item.data[item.dataID]["name"]
  end

  function item:getImage()
    if Item.image[item.dataID] then
      return Item.image[item.dataID]["image"]
    end
  end

  function item:getAnimImage()
    if Item.image[item.dataID] then
      return Item.image[item.dataID]["anim"]
    end
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

  function item:drawTo(sx, sy)
    local image = item:getImage()
    if image then
      love.graphics.setColor(255, 255, 255)
      love.graphics.draw(image, sx - 25, sy - 25)
    end
  end

  function item:getData()
    return Item.data[item.dataID]
  end

  if item:getType() == 3 then
    item.isMachine = true
  end

  return item
end

Item.data = {
  {id = 1, name = "default", type = 1, limit = 100},
  {id = 2, name = "wood", type = 2, limit = 100, src = "wood.png"},
  {id = 3, name = "stone", type = 2, limit = 100, src = "stone.png"},
  {id = 4, name = "iron ore", type = 2, limit = 100, src = "ironore.png"},
  {id = 5, name = "copper ore", type = 2, limit = 100, src = "copperore.png"},
  {id = 6, name = "iron ingot", type = 2, limit = 100, src = "ironingot.png"},
  {id = 7, name = "copper ingot", type = 2, limit = 100, src = "copperingot.png"},
  {id = 8, name = "stone brick", type = 2, limit = 100, src = "stonebrick.png"},
  {id = 9, name = "stone foundry", type = 3, subtype = 2, limit = 20, src = "foundry.png", fueltype= "item", fuel = {{id = 2, time = 50}}},
  {id = 10, name = "stone pickaxe", type = 4, subtype = 3, limit = 100, src = "stonepickaxe.png"},
  {id = 11, name = "iron gear", type = 2, limit = 100, src = "irongear.png"},
  {id = 12, name = "iron axe", type = 2, limit = 100},
  {id = 13, name = "iron plate", type = 2},
  {id = 14, name = "coal", type = 2},
  {id = 15, name = "steel ingot", type = 2},
  {id = 16, name = "steel gear", type = 2},
  {id = 17, name = "steel axe", type = 2},
  {id = 18, name = "steel plate", type = 2},
  {id = 19, name = "iron chain saw", type = 4, subtype = 2},
  {id = 20, name = "iron pickaxe", type = 4, subtype = 3},
  {id = 21, name = "steel pickaxe", type = 4, subtype = 3},
  {id = 22, name = "copper wire", type = 2},
  {id = 23, name = "copper coil", type = 2},
  {id = 24, name = "steam boiler", type = 2},
  {id = 25, name = "iron pipe", type = 2},
  {id = 26, name = "steel pipe", type = 2},
  {id = 27, name = "seal", type = 2},
  {id = 28, name = "oil", type = 2},
  {id = 29, name = "plastic", type = 2},
  {id = 30, name = "electric engine", type = 2},
  {id = 31, name = "iron anvil", type = 3, subtype = 4},
  {id = 32, name = "steel anvil", type = 3, subtype = 4},
  {id = 33, name = "oil refinery", type = 3, subtype = 5},
  {id = 34, name = "iron drill", type = 4, subtype = 3},
  {id = 35, name = "steel drill", type = 4, subtype = 4},
  {id = 36, name = "empty battery", type = 2},
  {id = 37, name = "battery", type = 2},
  {id = 38, name = "fuel can", type = 2},
  {id = 39, name = "empty can", type = 2},
  {id = 40, name = "charging station", type = 3, subtype = "?"}
}
Item.image = {}

for i, data in pairs(Item.data) do
  table.insert(Item.image, {id = i, image =  (data.src and love.graphics.newImage("sprite/"..data.src) or nil), anim =  (data.hasAnim and love.graphics.newImage("sprite/anim-"..data.src) or nil)})
end

local typeData = {{id = 1, name = "default"},
                  {id = 2, name = "ressource"},
                  {id = 3, name = "machine"},
                  {id = 4, name = "tool"}}

local machineSubtypeData = {{id = 1, type = "default"},
                            {id = 2, type = "furnace"},
                            {id = 3, type = "press"},
                            {id = 4, type = "anvil"},
                            {id = 5, type = "refinery"}}

local toolSubtypeData = {{id = 1, type = "default"},
                        {id = 2, type = "axe"},
                        {id = 3, type = "pickaxe"}}
return Item
