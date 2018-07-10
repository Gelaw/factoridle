local Item = {}

Item.stereotypes = {{idtype = 1, name = "default"},
                    {idtype = 2, name = "wood"},
                    {idtype = 3, name = "stone"},
                    {idtype = 4, name = "iron ore"},
                    {idtype = 5, name = "copper ore"},
                    {idtype = 6, name = "iron ingot"},
                    {idtype = 7, name = "copper ingot"},
                    {idtype = 8, name = "stone brick"}}
function Item:new()
  item = {}
  item.idtype = 0
  item.quantity = 0
  item.name = "default"

  function item:init(idtype, quantity)
    item.idtype = idtype
    item.quantity = quantity
    item.name = Item.stereotypes[idtype]["name"]
    --item.image = getItemImage(itemType)
  end



  return item
end
return Item
