local Item = require "item"
function newRecipePanel(recipe, name, position, dimensions)
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

function newRecipeList(recipes, name, position, dimensions)
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
      self:addElement(newRecipePanel(recipe, "recipe"..r, {x=0, y=ly}, {w=self.dimensions.w, h=60}), "recipe"..r)
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
