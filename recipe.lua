local Item = require "item"
local Recipe = {}

  function Recipe.getRecipes(machineSubtype)
    local recipes = {}
    for r, recipe in pairs(Recipe.data) do
      if recipe.machineSubtypeData == machineSubtype then
        table.insert(recipes, recipe)
      end
    end
    return recipes
  end

  Recipe.data =
  {{id = 1, machineSubtypeData = 2, intrants = {{itemID = 4, quantity = 2}},extrants = {{itemID = 6, quantity = 1}}, time = 3},
  {id = 2, machineSubtypeData = 2, intrants ={{itemID = 5, quantity = 2}}, extrants ={{itemID = 7, quantity = 1}}, time = 3},
  {id = 3, machineSubtypeData = "player", intrants = {{itemID = 3, quantity = 4}, {itemID=2, quantity=3}}, extrants = {{itemID = 9, quantity = 1}}, time = 5},
  {id = 4, machineSubtypeData = "player", intrants = {{itemID = 2, quantity = 1}, {itemID = 3, quantity = 2}}, extrants = {{itemID = 10, quantity = 1}}, time = 5}}

return Recipe
