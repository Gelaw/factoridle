local Item = require "item"
local Inventory = {}

  function Inventory:new()
    inventory = {}
    inventory.size = 20
    inventory.items = {}

    function inventory:init(size)
      inventory.size = size
    end

    function inventory:add(stack)
      for i = 1, #inventory.items, 1 do
        if inventory.items[i].type == stack.type then
          inventory.items[i].quantity = inventory.items[i].quantity + stack.quantity
          return
        end
      end
      table.insert(inventory.items, stack)
    end

    function inventory:removeQuantity(itemType, quantity)
      local stack = Item:new()
      stack:init(itemType, 0)
      for i = 1, #inventory.items, 1 do
        if inventory.items[i].type == stack.type then
          if inventory.items[i].quantity >= quantity then
            if inventory.items[i].quantity == quantity then
              table.remove(inventory.items, i)
            else
              inventory.items[i].quantity = inventory.items[i].quantity - quantity
            end
            stack.quantity = quantity
            return stack
          else
            quantity = quantity - inventory.items[i].quantity
            stack.quantity = inventory.items[i].quantity
            table.remove(inventory.items, i)
          end
        end
      end
      if stack.quantity > 0 then
        inventory:add(stack)
      end
      return false
    end

    function inventory:removeSlot(slot)
      if inventory.items[slot] then
        return table.remove(inventory.items, slot)
      end
    end

    function inventory:prompt()
      string = "inventory:"
      if #inventory.items == 0 then
        string = string .." empty."
      end
      for i = 1, #inventory.items, 1 do
        string = string .."\n   slot ".. i..": ".. inventory.items[i].quantity.. " " .. inventory.items[i].name
      end
      return string
    end

    return inventory
  end

return Inventory
