---@param model string|number
---@param coords vector3
---@param heading number
---@param isNetwork? boolean
---@param netMissionEntity? boolean
function vx.createVehicle(model, coords, heading, isNetwork, netMissionEntity)
   local function createVehicle()
      return CreateVehicle(model, coords.x, coords.y, coords.z, heading, isServerSide and true or (isNetwork or false),
         netMissionEntity or false)
   end

   local vehicle = vx.createEntity(createVehicle, model)
   return vehicle
end

return vx.createVehicle
