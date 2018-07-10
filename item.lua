local Item = {}

Item.stereotypes = {{type = 1, name = "default"},
                    {type = 2, name = "wood"},
                    {type = 3, name = "stone"},
                    {type = 4, name = "iron ore"},
                    {type = 5, name = "copper ore"},
                    {type = 6, name = "iron ingot"},
                    {type = 7, name = "copper ingot"},
                    {type = 8, name = "stone brick"}}
function Item:new()
  item = {}
  item.type = 0
  item.quantity = 0
  item.name = "default"

  function item:init(itemType, quantity)
    item.type = itemType
    item.quantity = quantity
    item.name = Item.stereotypes[itemType]["name"]
    --item.image = getItemImage(itemType)
  end



  return item
end
return Item
