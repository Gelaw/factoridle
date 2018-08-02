local Item = require "item"
require "ui.group"
require "ui.element"
require "ui.panel"

local GUI = {}


function GUI.newText(name,position,dimensions,pText, font, horizontalAlign, verticalAlign)
  local text = newPanel(name, position, dimensions)
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
    local x = self.position.x + xParent - xoffset
    local y = self.position.y + yParent - yoffset
    if self.horizontalAlign == "center" then
      x = x + ((text.dimensions.w - self.TextW) / 2)
    end
    if self.verticalAlign == "center" then
      y = y + ((self.dimensions.h - self.TextH) / 2)
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

function GUI.newButton(name,position,dimensions,pText,font)
  local button = newPanel(name,position,dimensions)
  button.transparent = false
  button.color = {r = 240, g = 240, b = 240}
  button.Text = pText
  if font then
    button.font = font
  else
    button.font = love.graphics.getFont()
  end
  local label = GUI.newText(name, {x=0, y=0}, {w=dimensions.w, h=dimensions.h}, pText, font, "center", "center")
  button:addElement(label, "label")
  label.transparent = true

  local pressedStatePanel = newPanel("pressed", {x=dimensions.w /10,y= dimensions.h/10},{w=8*dimensions.w/10, h=8*dimensions.h/10})
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

function GUI.newItemPanel(slot, position, item)
  local itemPanel = newPanel("slot "..slot, position, {w=48, h=48})
  itemPanel.item = item
  if item.dataID then
    itemPanel.image = item:getImage()
  end
  itemPanel.color = {r = 0, g = 200, b = 255, a = 100}

  local textPane = GUI.newText("itemQuantity",{x=itemPanel.dimensions.w/2,y=itemPanel.dimensions.h/2},{w=itemPanel.dimensions.w/2,h=itemPanel.dimensions.h/2},  (item.dataID and item.quantity  or  ""),love.graphics.getFont(),"center", "center")
  local pane = newPanel("panelquantity", {x=itemPanel.dimensions.w/2,y=itemPanel.dimensions.h/2},{w=itemPanel.dimensions.w/2,h=itemPanel.dimensions.h/2})
  pane.color = {r = 10, g = 10, b = 10, a = 100}
  pane.transparent = true
  textPane.transparent = true
  itemPanel:addElement(pane, "panelquantity")
  itemPanel:addElement(textPane, "itemQuantity")

  function itemPanel:update()
    if self.item.dataID and self.item.quantity then
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

function GUI.newInventoryPanel(name, position, inventory)
  local inventoryPanel =  newPanel(name, position,{w=inventory.size.width * 50 + 10, h=inventory.size.height * 50 + 10})

  function inventoryPanel:init()
    inventoryPanel.transparent = true
    inventoryPanel.color = {r = 255, g = 255, b = 255, a = 255}
    for j = 0, inventory.size.height - 1, 1 do
      for i = 0, inventory.size.width - 1, 1 do
        local slot = j * inventory.size.width + i + 1
        local itemPanel =  GUI.newItemPanel(slot,{x=i * 50 + 5,y=j * 50 + 5}, inventory.items[slot])
        inventoryPanel:addElement(itemPanel, slot)
        local fond = newPanel("fond"..slot,{x=i * 50 + 5,  y=j * 50 + 5}, {w=48,h=48})
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

function GUI.newRessourceGeneratorPanel(ressourceGenerator, position)
  local rgi = newPanel(ressourceGenerator:getName(), position,{w=400, h=300})

  function rgi:init()
    self.transparent = true
    rgi:addElement(GUI.newInventoryPanel("toolslot", {x=30,y= 50}, ressourceGenerator.inventories.toolSlot), "toolSlot")
    rgi:addElement(GUI.newInventoryPanel("inventory", {x=100, y=50}, ressourceGenerator.inventories.inventory), "inventory")
    local button = GUI.newButton("RG", {x=30, y=200},{w=50, h=50}, " ", love.graphics.getFont())
    rgi:addElement(button, "button")
    button.color = {r = 30, g = 150, b = 30}
    button.actionPerformed = function()
      ressourceGenerator:initGeneration()
    end
  end

  rgi:init()
  return rgi
end

function GUI.newMachinePanel(machine, position)
  local mi = newPanel(machine:getName(), position, {w=400, h=300})

  function mi:init()
    self.transparent = true
    mi:addElement(GUI.newInventoryPanel("input", {x=30, y=50}, machine.inventories.inputs), "input")
    mi:addElement(GUI.newInventoryPanel("output", {x=100, y=50}, machine.inventories.outputs), "output")
  end

  mi:init()
  return mi
end

function GUI.newRecipePanel(recipe, name, position, dimensions)
  local recipePanel = newPanel(name, position, dimensions)

  function recipePanel:init()
    self.transparent = false
    self.selected = false
    self.recipe = recipe
    local panel = newPanel("fond", {x=0,y=0},{w=self.dimensions.w,h=self.dimensions.h})
    panel.color = {r=0,g=0,b=0}
    panel.mode = "line"
    panel.transparent = true
    self.color = {r=240,g=240,b=240}
    self:addElement(panel, "fond")
    local ix = 5
    for e, extrant in pairs(recipe.extrants) do
      if e > 1 then
        local plus = GUI.newText("+"..e, {x=ix,y=5},{w=10,h=50},"+", love.graphics.getFont(), "center", "center")
        plus.color = {r = 0, g = 0, b = 0}
        plus.transparent = true
        recipePanel:addElement(plus, "+"..e)
        ix = ix + 20
      end
      local item = GUI.newItemPanel(e, {x=ix, y=5}, Item.new(extrant.itemID, extrant.quantity))
      item.transparent = true
      recipePanel:addElement(item, "extrant"..e)
      ix = ix + 60
    end
    local egal = GUI.newText(":", {x=ix,y=5},{w=10,h=50},":", love.graphics.getFont(), "center", "center")
    egal.color = {r = 0, g = 0, b = 0}
    egal.transparent = true
    recipePanel:addElement(egal, ":")
    ix = ix + 20
    for i, intrant in pairs(recipe.intrants) do
      if i > 1 then
        local plus = GUI.newText("+"..i, {x=ix,y=5},{w=10,h=50},"+", love.graphics.getFont(), "center", "center")
        plus.color = {r = 0, g = 0, b = 0}
        plus.transparent = true
        recipePanel:addElement(plus, "+"..i)
        ix = ix + 20
      end
      local item =GUI.newItemPanel(i, {x=ix, y=5}, Item.new(intrant.itemID, intrant.quantity))
      item.transparent = true
      recipePanel:addElement(item, "intrant"..i)
      ix = ix + 60
    end
  end

  function recipePanel:select()
    self.selected = true
    self:getElement("fond").color = {r = 0, g = 0, b = 200}
    self.color = {r=220,g=220,b=250}
  end

  function recipePanel:unselect()
    self.selected = false
    self:getElement("fond").color = {r = 0, g = 0, b = 0}
    self.color = {r=240,g=240,b=240}
  end

  recipePanel:init()
  return recipePanel
end

function GUI.newRecipeList(recipes, name, position, dimensions)
  local recipeList = newPanel(name, position, dimensions)

  function recipeList:init()
    local panel = newPanel("fond", {x=0,y=0},{w=self.dimensions.w,h=self.dimensions.h})
    panel.color = {r=0,g=0,b=0}
    panel.mode = "line"
    panel.transparent = true
    self.color = {r=240,g=240,b=240}
    self:addElement(panel, "fond")
    local  ly = 0
    for r, recipe in pairs(recipes) do
      self:addElement(GUI.newRecipePanel(recipe, "recipe"..r, {x=0, y=ly}, {w=self.dimensions.w, h=60}), "recipe"..r)
      ly = ly + 60
    end
  end

  function recipeList:onClick(x, y, button, isTouch)
    grab.status = "UI"
    grab.ui = self
    self.selectedRecipe = nil
    for n, v in pairs(self.elements) do
      if v.unselect then v:unselect() end
    end
    for n, v in pairs(self.elements) do
      if v:doesTouch(x - self.position.x, y - self.position.y) then
        v:select()
        self.selectedRecipe = v.recipe
        return
      end
    end
  end

  recipeList:init()
  return recipeList
end

function GUI.newPlayerGroup(player)
  local largeur = 400
  local playerGroup = newGroup("Inventaire", {x=width - largeur, y=0}, {w=largeur, h=height})
  local handleImage = love.graphics.newImage("sprite/handle2.png")

  function playerGroup:init()
    self.movable = false
    local playerPanel = newPanel("panel", {x=0, y=0}, {w=largeur, h=height})
    playerPanel.transparent = true
    playerGroup:addElement(playerPanel, "panel")
    local inventaire = GUI.newInventoryPanel("inventaire", {x=10, y=height}, player.inventory)
    inventaire.position.x = largeur - inventaire.dimensions.w - 10
    inventaire.position.y = height - inventaire.dimensions.h - 10
    playerPanel:addElement(inventaire, "inventaire")

    local recipeList = GUI.newRecipeList(player.recipes, "recipes", {x=100, y=30}, {w=largeur - 110, h=height - 60 - inventaire.dimensions.h})
    playerPanel:addElement(recipeList, "recipes")

    local buttonCraft = GUI.newButton("buttonCraft", {x=inventaire.position.x,y=inventaire.position.y - 80},{w=50,h=50}," ",love.graphics.getFont())
    buttonCraft.actionPerformed = function ()
      if recipeList.selectedRecipe then
        player:craft(recipeList.selectedRecipe)
      end
    end
    playerPanel:addElement(buttonCraft, "buttonCraft")
    self.elements["quit"] = nil
    local circle = newPanel("circle test", {x=30, y=30}, {shape = "circle", r = 25})
    circle.color.r = 0
    circle.color.b = 0
    playerPanel:addElement(circle, "circle test")
  end

  function playerGroup:doesTouch(x, y)
    if x> self.position.x and y > self.position.y and x < self.position.x + self.dimensions.w and y<self.position.y + self.dimensions.h and self.visible
      or x>self.position.x-30 and y>self.dimensions.h/2 - 30 and x<self.position.x and y<self.dimensions.h/2 + 30 then
      return true
    end
    return false
  end

  local speed = 500

  function playerGroup:update(dt)
    for n,v in pairs(self.elements) do
      v:update(dt)
    end
    if self.isHidding == true then
      local x = self.position.x + speed * dt
      if x > width then
        self.position.x = width
        self.visible = false
        self.isHidding = false
      else
        self.position.x = x
      end
      return
    end
    if self.isShowing == true then
      local x = self.position.x - speed * dt
      if x <  width - largeur then
        self.position.x =  width - largeur
        self.isShowing = false
      else
        self.position.x = x
      end
    end
  end

  function playerGroup:draw()
    if self.visible then
      for n,v in pairs(self.elements) do
        print(n)
        v:draw(self.position.x, self.position.y, self.dimensions.w, self.dimensions.h, 0, 0)
      end
    end
    love.graphics.draw(handleImage, self.position.x - 30, self.dimensions.h/2 - 30)
  end

  function playerGroup:toggle()
    if self.visible == false or self.isHidding == true then
      self:show()
      return
    end
    self:hide()
  end

  function playerGroup:hide()
    self.isHidding = true
    self.isShowing = false
  end

  function playerGroup:show()
    self.visible = true
    self.isHidding = false
    self.isShowing = true
  end

  function playerGroup:mousemoved(x, y, dx, dy)
    self.visible = true
    self.isHidding = false
    self.isShowing = false
    local px = self.position.x + dx
    if px < width and px > width - largeur then
      self.position.x = px
    end
  end

  function playerGroup:onRelease(x, y)
    for p, panel in pairs(self.elements) do
      if panel:doesTouch(x - self.position.x, y - self.position.y) then
        panel:onRelease(x - self.position.x, y - self.position.y, pButton)
        return
      end
    end
    if self.position.x < width - largeur / 2 then
      self:show()
    elseif self.position.x >= width - largeur / 2 then
      self:hide()
    end
  end

  playerGroup:init()
  return playerGroup
end
return GUI
