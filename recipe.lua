local Item = require "item"
local Recipe = {}

  function Recipe.getRecipes(machineSubtype)
    local recipes = {}
    for r, recipe in pairs(Recipe.data) do
      if recipe.machineSubtypeData then
        table.insert(recipes, recipe)
      end
    end
    return recipes
  end

  Recipe.data =
  {{id = 1, machineSubtypeData = 2, intrants = {{itemID = 4, quantity = 2}},extrants = {{itemID = 6, quantity = 1}}, canPlayerCraft = false, time = 3},
    {id = 2, machineSubtypeData = 2, intrants ={{itemID = 5, quantity = 2}}, extrants ={{itemID = 7, quantity = 1}}, canPlayerCraft = false, time = 3}}

return Recipe
