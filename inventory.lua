local Inventory = {}

  function Inventory:new()
    inventory = {}
    inventory.size = 20
    inventory.items = {}

    function inventory:init(size)
      inventory.size = size
    end

    function add(item)
      
    end

    return Inventory
  end

return Inventory
