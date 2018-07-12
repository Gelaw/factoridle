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
      for i, item in pairs(inventory.items) do
        if item ~= "empty" and item.idtype == stack.idtype then
          item.quantity = item.quantity + stack.quantity
          return
        elseif item == "empty" then
          inventory.items[i] = stack
          return
        end
      end
    end

    function inventory:removeQuantity(itemType, quantity)
      local stack = Item:new()
      stack:init(itemType, 0)
      for i, item in pairs(inventory.items) do
        if item.idtype == stack.idtype then
          if item.quantity >= quantity then
            if item.quantity == quantity then
              inventory.items[i] = "empty"
            else
              item.quantity = item.quantity - quantity
            end
            stack.quantity = quantity
            return stack
          else
            quantity = quantity - item.quantity
            stack.quantity = item.quantity
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
      local string = "inventory:"
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
