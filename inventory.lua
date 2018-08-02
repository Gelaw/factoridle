local Item = require "item"
local Inventory = {}

  function Inventory.new(size)
    local inventory = {}
    inventory.size = size
    inventory.filters = {}
    inventory.canPlayerAdd = true
    inventory.items = {}
    for i = 1, size.width * size.height, 1 do
      inventory.items[i] = "empty"
    end

    function inventory:add(stack)
      for i, item in pairs(inventory.items) do
        if item ~= "empty" and item.dataID == stack.dataID then
          item.quantity = item.quantity + stack.quantity
          return true
        elseif item == "empty" then
          inventory.items[i] = stack
          return true
        end
      end
      return false
    end

    function inventory:put(stack, slot)
      if not inventory.items[slot] then
        return false
      end
      if inventory.items[slot] == "empty" then
        inventory.items[slot] = stack
        return true
      elseif inventory.items[slot].dataID == stack.dataID then
        inventory.items[slot].quantity = inventory.items[slot].quantity + stack.quantity
        return true
      end
      return false
    end

    function inventory:removeQuantityOf(dataID, quantity)
      local stack = Item.new(dataID, 0)
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
            stack.quantity = stack.quantity + item.quantity
            inventory.items[i] = "empty"
          end
        end
      end
      if quantity > 0 then
        inventory:add(stack)
      end
      return false
    end

    function inventory:removeQuantityFrom(slot, quantity)
      if inventory.items[slot] == nil
      or inventory.items[slot] == "empty"
      or quantity > inventory.items[slot].quantity
      then return false end
      local stack = Item.new(inventory.items[slot].dataID, quantity)
      inventory.items[slot].quantity = inventory.items[slot].quantity - quantity
      if inventory.items[slot].quantity == 0 then
        inventory.items[slot] = "empty"
      end
      return stack
    end

    function inventory:removeSlot(slot)
      if inventory.items[slot] ~= "empty" then
        local stack = inventory.items[slot]
        inventory.items[slot] = "empty"
        return stack
      end
    end

    function inventory:isEmpty()
      for i, slot in pairs(self.items) do
        if slot ~= "empty" then
          return false
        end
      end
      return true
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

    function inventory:doesContain(dataID, quantity)
      for i, item in pairs(self.items) do
        if item.dataID then
          if item.dataID == dataID then
            if quantity <=  item.quantity then
              return true
            else
              quantity = quantity - item.quantity
            end
          end
        end
      end
      return false
    end

    function inventory:doesContainAll(items)
      for i, item in pairs(items) do
        if not self:doesContain(item.itemID, item.quantity) then
          return false
        end
      end
      return true
    end

    return inventory
  end

return Inventory
