local Inventory = {}

  function Inventory:new()
    inventory = {}
    inventory.size = 20
    inventory.items = {}

    function inventory:init(size)
      inventory.size = size
    end

    function add(stack)
      
    end

    return Inventory
  end

return Inventory
