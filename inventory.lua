local Item = require "item"
local Inventory = {}

  function Inventory:new()
    inventory = {}
    inventory.size = 20
    inventory.items = {}

    function inventory:init(size)
      inventory.size = size
      for i = 1, size, 1 do
        inventory.items[i] = "empty"
      end
    end

    function inventory:add(stack)
      for i = 1, inventory.size, 1 do
        if inventory.items[i] ~= "empty" and inventory.items[i].type == stack.type then
          inventory.items[i].quantity = inventory.items[i].quantity + stack.quantity
          return
        elseif inventory.items[i] == "empty" then
          inventory.items[i] = stack
          return
        end
      end
    end

    function inventory:removeQuantity(itemType, quantity)
      local stack = Item:new()
      stack:init(itemType, 0)
      for i = 1, #inventory.items, 1 do
        if inventory.items[i].type == stack.type then
          if inventory.items[i].quantity >= quantity then
            if inventory.items[i].quantity == quantity then
              inventory.items[i] = "empty"
            else
              inventory.items[i].quantity = inventory.items[i].quantity - quantity
            end
            stack.quantity = quantity
            return stack
          else
            quantity = quantity - inventory.items[i].quantity
            stack.quantity = inventory.items[i].quantity
            inventory.items[i] = "empty"
          end
        end
      end
      if stack.quantity > 0 then
        inventory:add(stack)
      end
      return false
    end

    function inventory:removeSlot(slot)
      if inventory.items[slot] ~= "empty" then
        local stack = inventory.items[slot]
        inventory.items[slot] = "empty"
        return stack
      end
    end

    function inventory:prompt()
      string = "inventory:"
      for i = 1, inventory.size, 1 do
        string = string .."\n   slot ".. i..": "
        if inventory.items[i] ~= "empty" then
           string  = string .. inventory.items[i].quantity.. " " .. inventory.items[i].name
         else
            string  = string .. "empty."
         end
      end
      return string
    end

    return inventory
  end

return Inventory
