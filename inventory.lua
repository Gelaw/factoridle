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
      for i = 1, #items, 1 do
        if items[i].type == stack.type then
          items[i].quantity = items[i].quantity + stack.quantity
          return
        end
      end
      table.insert(items, stack)
    end

    function inventory:removeQuantity(itemType, quantity)
      local stack = Item:new()
      stack:init(itemType, 0)
      for i = 1, #items, 1 do
        if items[i].type == stack.type then
          if items[i].quantity >= quantity then
            if items[i].quantity == quantity then
              table.remove(items, i)
            else
              items[i].quantity = items[i].quantity - quantity
            end
            stack.quantity = quantity
            return stack
          else
            quantity = quantity - items[i].quantity
            stack.quantity = items[i].quantity
            table.remove(items, i)
          end
        end
      end
      if stack.quantity > 0 then
        inventory:add(stack)
      end
      return false
    end

    function inventory:removeSlot(slot)
      if items[slot] then
        return table.remove(slot)
      end
    end

    return Inventory
  end

return Inventory
