local Item = require "item"
local Inventory = {}

  function Inventory:new(size)
    local inventory = {}
    inventory.size = size
    inventory.items = {}
    for i = 1, size, 1 do
      inventory.items[i] = "empty"
    end

    function inventory:add(stack)
      for i, item in pairs(inventory.items) do
        if item ~= "empty" and item.dataID == stack.dataID then
          item.quantity = item.quantity + stack.quantity
          stack:dragOnInventory()
          return true
        elseif item == "empty" then
          inventory.items[i] = stack
          stack:dragOnInventory()
          return true
        end
      end
    end

    function inventory:removeQuantity(dataID, quantity)
      local stack = Item:new()
      stack:init(itemType, 0)
      for i, item in pairs(inventory.items) do
        if item.dataID == stack.dataID then
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

    function inventory:removeSlot(slot, quantity)
      if quantity == nil then
        quantity = 1
      end
      if inventory.items[slot] ~= "empty" then
        local stack = inventory.items[slot]
        if stack.quantity < quantity then
          return nil
        end
        if stack.quantity == quantity then
          inventory.items[slot] = "empty"
          return stack
        end
        stack.quantity = stack.quantity - quantity
        return Item:new(stack.dataID, quantity)
      end
    end

    function inventory:prompt()
      local string = "inventory:"
      for i, item in pairs(inventory.items) do
        string = string .."\n   slot ".. i..": "
        if item ~= "empty" then
           string  = string .. item.quantity.. " " .. item:getName()
         else
            string  = string .. "empty."
         end
      end
      return string
    end

    function inventory:dragItemOnSlot(item, slot)
      if not inventory.items[slot] then
      elseif inventory.items[slot] == "empty" then
        item:dragOnInventory()
        inventory.items[slot] = item
      elseif inventory.items[slot].type == item.type then
        inventory.items[slot].quantity = inventory.items[slot].quantity + item.quantity
      end
    end

    function inventory:dragItemOnWorld(slot, pos)
      if not inventory.items[slot] then
      elseif inventory.items[slot].isMachine == true then
       local item = inventory:removeSlot(slot)
       item:dropOnWorld(pos)
      end
    end

    return inventory
  end

return Inventory
