
function newInventoryPanel(name, position, inventory)
  local inventoryPanel =  newPanel(name, position,{w=inventory.size.width * 50 + 10, h=inventory.size.height * 50 + 10})

  function inventoryPanel:init()
    self.transparent = true
    self.color = {r = 200, g = 255, b = 255, a = 245}
    for j = 0, inventory.size.height - 1, 1 do
      for i = 0, inventory.size.width - 1, 1 do
        local slot = j * inventory.size.width + i + 1
        local itemPanel =  newItemPanel(slot,{x=i * 50 + 5,y=j * 50 + 5}, inventory.items[slot])
        self:addElement(itemPanel, slot)
      end
    end
  end

  function inventoryPanel:refresh()
    for n,v in pairs(self.elements) do
      if inventory.items[n] then
        v.item = inventory.items[n]
        v:update()
      end
    end
  end

  function inventoryPanel:onClick(x, y, pButton)
    for n,v in pairs(self.elements) do
      if v:doesTouch(x - self.position.x, y - self.position.y) then
        if inventory.items[n] and inventory.items[n]~="empty" then
          v:onClick(x, y, button)
          grab.status = "item"
          grab.item = inventory.items[n]
          grab.inventory = inventory
          grab.slot = n
        else
          grab.status = "UI"
          grab.ui = self
        end
      end
    end
  end

  function inventoryPanel:onRelease(x, y, pButton)
    if not grab or inventory.canPlayerAdd == false then
      return
    end
    local stack = nil
    if grab.status == "item" then
      stack = grab.inventory.items[grab.slot]
    elseif grab.status == "entity" and grab.entity.item then
      stack = grab.entity.item
    end
    if not stack then
      return
    end
    for n,v in pairs(self.elements) do
      if grab.inventory ~= inventory or grab.slot ~= n then
        if v:doesTouch(x - self.position.x, y - self.position.y) then
          if grab.status == "item" and inventory:put(stack, n) then
            grab.inventory:removeSlot(grab.slot)
          elseif grab.status == "entity" and grab.entity.item and grab.entity:doesntHave(inventory) and grab.entity:isEmpty() and inventory:put(stack, n)then
            world:removeEntity(grab.entity)
          end
        end
      end
    end
  end

  function inventoryPanel:update()
    self:refresh()
  end

  inventoryPanel:init()
  return inventoryPanel
end
