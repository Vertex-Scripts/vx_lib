---@param model string|number
---@param coords vector3
---@param heading number
---@param isNetwork? boolean
---@param netMissionEntity? boolean
---@param waitForEntity? boolean Waits for the entity to spawn, defaults to true
function vx.createVehicle(model, coords, heading, isNetwork, netMissionEntity, waitForEntity)
   local function createVehicle()
      return CreateVehicle(model, coords.x, coords.y, coords.z, heading, isServerSide and true or (isNetwork or false),
         netMissionEntity or false)
   end

   local vehicle = vx.createEntity(createVehicle, model, waitForEntity)
   return vehicle
end

return vx.createVehicle
