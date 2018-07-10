local Machine = {}

Machine.type = {{id = 1, name = "default"},
                {id = 2, name = "furnace"}}

Machine.stereotypes = {{id = 1, name = "default", type = 1},
                      {id = 2, name = "stone furnace", type = 2}}

function Machine:new()


  return machine
end

return Machine
