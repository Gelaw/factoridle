local Item = require "item"
require "ui.group"
require "ui.element"
require "ui.panel"
require "ui.textPanel"
require "ui.button"
require "ui.item.itemPanel"
require "ui.item.inventoryPanel"


local GUI = {}

function GUI.newRessourceGeneratorPanel(ressourceGenerator, position)
  local rgi = newPanel(ressourceGenerator:getName(), position,{w=400, h=300})

  function rgi:init()
    self.transparent = true
    self.color.b = 150
    self.color.r = 200
    rgi:addElement(newInventoryPanel("toolslot", {x=30,y= 50}, ressourceGenerator.inventories.toolSlot), "toolSlot")
    rgi:addElement(newInventoryPanel("inventory", {x=100, y=50}, ressourceGenerator.inventories.inventory), "inventory")
    local button = newButton("RG", {x=55, y=225},{shape="circle",r=25}, " ", love.graphics.getFont())
    rgi:addElement(button, "button")
    button.color = {r = 30, g = 150, b = 30}
    button.actionPerformed = function()
      ressourceGenerator:initGeneration()
    end
    button.image = ressourceGenerator:getImage()
  end

  rgi:init()
  return rgi
end

function GUI.newMachinePanel(machine, position)
  local mi = newPanel(machine:getName(), position, {w=400, h=300})

  function mi:init()
    self.transparent = true
    mi:addElement(newInventoryPanel("input", {x=30, y=50}, machine.inventories.inputs), "input")
    mi:addElement(newInventoryPanel("output", {x=100, y=50}, machine.inventories.outputs), "output")
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
        local plus = newText("+"..e, {x=ix,y=5},{w=10,h=50},"+", love.graphics.getFont(), "center", "center")
        plus.color = {r = 0, g = 0, b = 0}
        plus.transparent = true
        recipePanel:addElement(plus, "+"..e)
        ix = ix + 20
      end
      local item = newItemPanel(e, {x=ix, y=5}, Item.new(extrant.itemID, extrant.quantity))
      item.transparent = true
      recipePanel:addElement(item, "extrant"..e)
      ix = ix + 60
    end
    local egal = newText(":", {x=ix,y=5},{w=10,h=50},":", love.graphics.getFont(), "center", "center")
    egal.color = {r = 0, g = 0, b = 0}
    egal.transparent = true
    recipePanel:addElement(egal, ":")
    ix = ix + 20
    for i, intrant in pairs(recipe.intrants) do
      if i > 1 then
        local plus = newText("+"..i, {x=ix,y=5},{w=10,h=50},"+", love.graphics.getFont(), "center", "center")
        plus.color = {r = 0, g = 0, b = 0}
        plus.transparent = true
        recipePanel:addElement(plus, "+"..i)
        ix = ix + 20
      end
      local item =newItemPanel(i, {x=ix, y=5}, Item.new(intrant.itemID, intrant.quantity))
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
    local inventaire = newInventoryPanel("inventaire", {x=10, y=height}, player.inventory)
    inventaire.position.x = largeur - inventaire.dimensions.w - 10
    inventaire.position.y = height - inventaire.dimensions.h - 10
    playerPanel:addElement(inventaire, "inventaire")

    local recipeList = GUI.newRecipeList(player.recipes, "recipes", {x=100, y=30}, {w=largeur - 110, h=height - 60 - inventaire.dimensions.h})
    playerPanel:addElement(recipeList, "recipes")

    local buttonCraft = newButton("buttonCraft", {x=inventaire.position.x,y=inventaire.position.y - 80},{w=50,h=50}," ",love.graphics.getFont())
    buttonCraft.actionPerformed = function ()
      if recipeList.selectedRecipe then
        player:craft(recipeList.selectedRecipe)
      end
    end
    playerPanel:addElement(buttonCraft, "buttonCraft")
    self.elements["quit"] = nil
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
      local myStencilFunction = function ()
        love.graphics.rectangle("fill", self.position.x, self.position.y, self.dimensions.w, self.dimensions.h)
      end
      for n,v in pairs(self.elements) do
        v:draw(self.position.x, self.position.y, myStencilFunction, 1)
      end
    end
    love.graphics.setColor(255, 255, 255)
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
