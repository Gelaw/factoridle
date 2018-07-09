local ItemDoc = require "itemdoc"
local Item = {}
function Item:new()
  item = {}
  item.image = ""
  item.type = 0
  item.quantity = 0

  function item:init(itemType, quantity)
    item.type = itemType
    item.quantity = quantity
    item.image = getItemImage(itemType)
  end

  return item
end
return Item
