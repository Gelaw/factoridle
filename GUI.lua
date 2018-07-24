local GUI = {}

function GUI.newGroup(key, x, y, w, h)
  local group = {}
  group.elements = {}
  group.key = "defaultKey"
  group.x = x
  group.y = y
  group.w = w
  group.h = h
  group.visible = true
  group.movable = true

  function group:addElement(element, id)
    if self.elements[id] == nil then
        self.elements[id] = element
        return true
    end
    return false
  end

  function group:getElement(id)
    for eid, element in pairs(self.elements) do
      if eid == id then
        return element
      end
    end
  end

  function group:draw()
    if self.visible then
      for n,v in pairs(self.elements) do
        v:draw(self.x, self.y, self.w, self.h, 0, 0)
      end
    end
  end

  function group:update(dt)
    for n,v in pairs(self.elements) do
      v:update(dt)
    end
  end

  function group:setVisible(visible)
    self.visible = visible
  end

  function group:doesTouch(x, y)
    if x> self.x and y > self.y and x < self.x + self.w and y<self.y + self.h and self.visible then
      return true
    end
    return false
  end

  function group:onClick(x, y, pButton)
    for p, panel in pairs(self.elements) do
      if panel:doesTouch(x - self.x, y - self.y) then
        panel:onClick(x - self.x, y - self.y, pButton)
        return
      end
    end
    grab.status = "UI"
    grab.ui = self
  end

  function group:mousemoved(x, y, dx, dy)
    if self.movable then
      self.x = self.x + dx
      self.y = self.y + dy
    end
  end

  function group:onRelease(x, y, pButton)
    for p, panel in pairs(self.elements) do
      if panel:doesTouch(x - self.x, y - self.y) then
        panel:onRelease(x - self.x, y - self.y, pButton)
        return
      end
    end
  end

  function group:resetClick()
    for p, panel in pairs(self.elements) do
      panel:resetClick()
    end
  end
  return group
end

local function newElement(name, x, y)
  local element = {}

  element.x = x
  element.y = y
  element.visible = true
  element.name = name
  element.isPressed = false

  function element:draw(xParent, yParent)
    print("newElement / draw / TODO")
  end

  function element:update(dt)

  end

  return element
end

function GUI.newPanel(name,x,y,w,h)
  local panel = newElement(name,x, y)
  panel.w = w
  panel.h = h
  panel.image = nil
  panel.elements = {}
  panel.listEvents = {}
  panel.color = {r = 255, g = 255, b = 255, a = 255}
  panel.transparent = false
  panel.mode = "fill"

  function panel:addElement(element, id)
    if self.elements[id] == nil then
        self.elements[id] = element
        return true
    end
    return false
  end

  function panel:getElement(id)
    for eid, element in pairs(self.elements) do
      if eid == id then
        return element
      end
    end
  end

  function panel:setImage(image)
    self.image = image
    self.w = image:getWidth()
    self.h = image:getHeight()
  end

  function panel:setEvent(eventType, pFunction)
    self.listEvents[eventType] = pFunction
  end

  function panel:draw(xParent, yParent, wParent, hParent, xoffset, yoffset)
    if not self.visible then return end
    local sx = self.x - xoffset
    local sy = self.y - yoffset
    if sx > wParent or
       sy > hParent or
       sx < -self.w or
       sy < -self.h then
      return
    end

    if self.x + self.w < xoffset or
      self.y + self.h < yoffset then
      return
    end

    local x, y, w, h = 0,0,0,0

    if sy< 0 and self.y-yoffset + self.h > hParent then
      y = yParent
      h = hParent
    elseif sy< 0 then
      y = yParent
      h = self.h + sy
    elseif sy + self.h > hParent then
      y = yParent + sy
      h = hParent - sy
    else
      y = yParent + sy
      h = self.h
    end

    if sx< 0 and self.x-xoffset + self.w > wParent then
      x = xParent
      w = wParent
    elseif sx< 0 then
      x = xParent
      w = self.w + sx
    elseif sx + self.w > wParent then
      x = xParent + sx
      w = wParent - sx
    else
      x = xParent + sx
      w = self.w
    end

    if self.image == nil then
      love.graphics.setColor(panel.color.r, panel.color.g, panel.color.b, panel.color.a)
      love.graphics.rectangle(self.mode, x, y, w, h)
    else
      love.graphics.setColor(255,255,255)
      love.graphics.draw(self.image, x, y, 0, 1, 1, xoffset, yoffset)
    end
    for n,v in pairs(panel.elements) do
      v:draw(x, y, w, h, sx <0 and -sx or 0, sy<0 and - sy or 0)
    end
  end

  function panel:update(dt)
    for n,v in pairs(panel.elements) do
      v:update(dt)
    end
  end

  function panel:resetClick()
    for p, v in pairs(self.elements) do
      v:resetClick()
    end
  end

  function panel:hover()
    local mx, my = love.mouse.getPosition()
    if mx > self.x and mx < self.x + self.w and
      my > self.y and my < self.y + self.h then
        if self.isHover == false then
          self.isHover = true
          if self.listEvents["hover"] ~= nil and self.visible == true then
            self.listEvents["hover"](self)
          end
        end
    else
      if self.isHover == true then
        self.isHover = false
      end
    end
  end

  function panel:doesTouch(x, y)
    for p, v in pairs(self.elements) do
      if v:doesTouch(x - self.x, y - self.y) then
        return true
      end
    end
    if x> self.x and y > self.y and x < self.x + self.w and y<self.y + self.h and self.transparent == false then
      return true
    end
    return false
  end

  function panel:onClick(x, y, pButton)
    for p, v in pairs(self.elements) do
      if v:doesTouch(x - self.x, y - self.y) then
        v:onClick(x - self.x, y - self.y, pButton)
        return
      end
    end
  end

  function panel:onRelease(x, y, pButton)
    for p, v in pairs(self.elements) do
      if v:doesTouch(x - self.x, y - self.y) then
        v:onRelease(x - self.x, y - self.y, pButton)
        return
      end
    end
  end

  function panel:resetClick()
    for n, v in pairs(self.elements) do
      v:resetClick()
    end
  end

  return panel
end

function GUI.newText(name,x,y,w,h,pText, font, horizontalAlign, verticalAlign)
  local text = GUI.newPanel(name,x, y, w, h)
  text.Text = pText
  text.font = font
  text.TextW = font:getWidth(pText)
  text.TextH = font:getHeight(pText)
  text.horizontalAlign = horizontalAlign
  text.verticalAlign = verticalAlign
  text.color = {r = 255, g = 255, b = 255}

  function text:draw(xParent, yParent,  wParent, hParent, xoffset, yoffset)
    love.graphics.setColor(text.color.r, text.color.g, text.color.b)
    love.graphics.setFont(self.font)
    local x = self.x + xParent - xoffset
    local y = self.y + yParent - yoffset
    if self.horizontalAlign == "center" then
      x = x + ((text.w - self.TextW) / 2)
    end
    if self.verticalAlign == "center" then
      y = y + ((self.h - self.TextH) / 2)
    end
    love.graphics.print(self.Text, x, y)
  end

  function text:setText(ptext)
    text.Text = ptext
    text.TextW = font:getWidth(ptext)
    text.TextH = font:getHeight(ptext)
  end

  function text:update(dt)
  end

  return text
end

function GUI.newButton(name,x,y,w,h,pText,font)
  local button = GUI.newPanel(name,x, y, w, h)
  button.transparent = false
  button.color = {r = 240, g = 240, b = 240}
  button.Text = pText
  if font then
    button.font = font
  else
    button.font = love.graphics.getFont()
  end
  local label = GUI.newText(name, 0, 0, w, h, pText, font, "center", "center")
  button:addElement(label, "label")
  label.transparent = true

  local pressedStatePanel = GUI.newPanel("pressed", w /10, h/10, 8 * w/10, 8* h/10)
  pressedStatePanel.transparent = true
  pressedStatePanel.color = {r = 0, g = 0, b = 0}
  pressedStatePanel.visible = false
  pressedStatePanel.mode = "line"
  button:addElement(pressedStatePanel, "pressedStatePanel")

  button.actionPerformed = nil

  function button:onClick(x, y , pButton)
    pressedStatePanel.visible = true
    grab.status = "UI"
    grab.ui = self
  end

  function button:onRelease(x, y, pButton)
   if pressedStatePanel.visible then
    pressedStatePanel.visible = false
    if self.actionPerformed then
      self.actionPerformed()
    end
   end
  end

  function button:resetClick()
    if pressedStatePanel.visible then
      pressedStatePanel.visible = false
    end
  end

  return button
end

function GUI.newItemPanel(slot, x, y, item)
  local itemPanel = GUI.newPanel("slot "..slot, x, y, 48, 48)
  itemPanel.item = item
  if item.dataID then
    itemPanel.image = item:getImage()
  end
  itemPanel.color = {r = 0, g = 200, b = 255, a = 100}

  local textPane = GUI.newText("itemQuantity", itemPanel.w/2,itemPanel.h/2,itemPanel.w/2,itemPanel.h/2,  (item.dataID and item.quantity  or  ""),love.graphics.getFont(),"center", "center")
  local pane = GUI.newPanel("panelquantity", itemPanel.w/2,itemPanel.h/2,itemPanel.w/2,itemPanel.h/2)
  pane.color = {r = 10, g = 10, b = 10, a = 100}
  pane.transparent = true
  textPane.transparent = true
  itemPanel:addElement(pane, "panelquantity")
  itemPanel:addElement(textPane, "itemQuantity")

  function itemPanel:update()
    if self.item.dataID then
      self:getElement("itemQuantity"):setText(self.item.quantity)
      self.image = self.item:getImage()
      self.visible = true
    else
      self:getElement("itemQuantity"):setText("")
      self.image = nil
      self.visible = false
    end
  end

  function itemPanel:onClick(x, y, button)
    self.color.a = 50
  end

  function itemPanel:resetClick()
    self.color.a = 100
  end
  return itemPanel
end

function GUI.newInventoryPanel(name, x, y, inventory)
  local inventoryPanel =  GUI.newPanel(name, x, y, inventory.size.width * 50 + 10, inventory.size.height * 50 + 10)

  function inventoryPanel:init()
    inventoryPanel.transparent = true
    inventoryPanel.color = {r = 255, g = 255, b = 255, a = 255}
    for j = 0, inventory.size.height - 1, 1 do
      for i = 0, inventory.size.width - 1, 1 do
        local slot = j * inventory.size.width + i + 1
        local itemPanel =  GUI.newItemPanel(slot,i * 50 + 5, j * 50 + 5, inventory.items[slot])
        inventoryPanel:addElement(itemPanel, slot)
        local fond = GUI.newPanel("fond"..slot, i * 50 + 5,  j * 50 + 5, 48,48)
        fond.color = {r = 0, g = 0, b = 0}
        fond.mode = "line"
        fond.transparent = true
        inventoryPanel:addElement(fond, "fond"..slot)
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
      if v:doesTouch(x - self.x, y - self.y) then
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
    if not grab then
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
        if v:doesTouch(x - self.x, y - self.y) and inventory:put(stack, n) then
          if grab.status == "item" then
            grab.inventory:removeSlot(grab.slot)
          elseif grab.status == "entity" and grab.entity.item then
            world:removeEntity(grab.entity)
          end
          self:refresh()
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

function GUI.newRessourceGeneratorPanel(ressourceGenerator, x, y)
  local rgi = GUI.newPanel(ressourceGenerator:getName(), x, y, 400, 300)

  function rgi:init()
    self.transparent = true
    rgi:addElement(GUI.newInventoryPanel("toolslot", 30, 50, ressourceGenerator.toolSlot), "toolSlot")
    rgi:addElement(GUI.newInventoryPanel("inventory", 100, 50, ressourceGenerator.inventory), "inventory")
    local button = GUI.newButton("RG", 30, 200, 50, 50, " ", love.graphics.getFont())
    rgi:addElement(button, "button")
    button.color = {r = 30, g = 150, b = 30}
    button.actionPerformed = function()
      ressourceGenerator:initGeneration()
    end
  end

  rgi:init()
  return rgi
end

function GUI.newMachinePanel(machine, x, y)
  local mi = GUI.newPanel(machine:getName(), x, y, 400, 300)

  function mi:init()
    self.transparent = true
    mi:addElement(GUI.newInventoryPanel("input", 30, 50, machine.inputs), "input")
    mi:addElement(GUI.newInventoryPanel("output", 100, 50, machine.outputs), "output")
  end

  mi:init()
  return mi
end
return GUI
