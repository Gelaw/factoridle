hatches = love.graphics.newImage("sprite/hatches.png")

require "ui.group"
require "ui.element"
require "ui.panel"
require "ui.label"
require "ui.button"
require "ui.item.itemPanel"
require "ui.item.inventoryPanel"
require "ui.item.recipePanels"

local GUI = {}

function GUI.newRessourceGeneratorPanel(ressourceGenerator, position)
  local rgi = newPanel(ressourceGenerator:getName(), position,{w=400, h=300})
  local button

  function rgi:init()
    self.transparent = true
    self.color.b = 150
    self.color.r = 200
    rgi:addElement(newInventoryPanel("toolslot", {x=30,y= 50}, ressourceGenerator.inventories.toolSlot), "toolSlot")
    rgi:addElement(newInventoryPanel("inventory", {x=100, y=50}, ressourceGenerator.inventories.inventory), "inventory")
    button = newButton("RG", {x=55, y=225},{shape="circle",r=25}, " ", love.graphics.getFont())
    rgi:addElement(button, "button")
    button.color = {r = 200, g = 200, b = 200}
    button.actionPerformed = function()
      if ressourceGenerator:initGeneration() then
        button:addTimer(ressourceGenerator.timer)
      end
    end
    button.image = ressourceGenerator:getImage()
  end

  function rgi:update(dt)
    for n, v in pairs(self.elements) do
      v:update(dt)
    end
    button.active = ressourceGenerator:canGenerate()
  end

  rgi:init()
  return rgi
end

function GUI.newMachinePanel(machine, position)
  local mi = newPanel(machine:getName(), position, {w=400, h=300})
  function mi:init()
    self.transparent = true
    mi:addElement(newInventoryPanel("input", {x=30, y=50}, machine.inventories.inputs), "input")
    if machine.inventories.fuel then
      mi:addElement(newInventoryPanel("input", {x=150, y=50}, machine.inventories.fuel), "fuel")
    end
    local fuelBar = newPanel("fuelBar", {x=150, y=200}, {w=50, h=10})
    fuelBar.color = {r=30, g=30, b= 30}
    local fuelLoadBar = newPanel("fuelLoadBar", {x=0, y=0}, {w=0, h= 10})
    fuelLoadBar.color = {r=255, g=0, b = 0, a = 90}
    fuelLoadBar.update = function()
      if  machine.fuelTimer and machine.fuelTimer > 0 then
        fuelLoadBar.dimensions.w = fuelBar.dimensions.w * machine.fuelTimer / machine.fuelTimerBase
      end
    end
    fuelBar:addElement(fuelLoadBar, "fuelLoadBar")
    mi:addElement(fuelBar, "fuelBar")
    mi:addElement(newInventoryPanel("output", {x=300, y=50}, machine.inventories.outputs), "output")
  end

  mi:init()
  return mi
end

function GUI.newPlayerGroup(player)
  local largeur = 400
  local playerGroup = newGroup("Inventaire", {x=width, y=0}, {w=largeur, h=height})
  local handleImage = love.graphics.newImage("sprite/handle.png")
  local inventaire, buttonCraft, recipeList

  function playerGroup:init()
    self.movable = false
    local playerPanel = newPanel("panel", {x=0, y=0}, {w=largeur, h=height})
    playerPanel.transparent = true
    playerGroup:addElement(playerPanel, "panel")
    inventaire = newInventoryPanel("inventaire", {x=10, y=height}, player.inventory)
    inventaire.position.x = largeur - inventaire.dimensions.w - 10
    inventaire.position.y = height - inventaire.dimensions.h - 10
    playerPanel:addElement(inventaire, "inventaire")

    recipeList = newRecipeList(player.recipes, "recipes", {x=100, y=30}, {w=largeur - 110, h=height - 60 - inventaire.dimensions.h})
    playerPanel:addElement(recipeList, "recipes")

    buttonCraft = newButton("buttonCraft", {x=inventaire.position.x,y=inventaire.position.y - 80},{w=50,h=50}," ",love.graphics.getFont())
    buttonCraft.actionPerformed = function ()
      if recipeList.selectedRecipe then
        if player:craft(recipeList.selectedRecipe) then
          buttonCraft:addTimer(recipeList.selectedRecipe.time)
        end
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
    if recipeList.selectedRecipe and player.isCrafting == false then
      if player.inventory:doesContainAll(recipeList.selectedRecipe.intrants) then
        buttonCraft.active = true
        return
      end
    end
    buttonCraft.active = false
    if self.isShowing == false and self.isHidding == false and (grab.status ~= "UI" or grab.ui ~= self) then
      if self.position.x < width - largeur / 2 then
        self:show()
      elseif self.position.x >= width - largeur / 2 then
        self:hide()
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
  end

  playerGroup:init()
  return playerGroup
end
return GUI
