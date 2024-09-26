local isServerSide = IsDuplicityVersion()

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

   if type(model) == "string" then
      model = joaat(model)
   end

   if isServerSide then
      local vehicle = createVehicle()
      vx.waitFor(function()
         if DoesEntityExist(vehicle) then
            return true
         end
      end, "Failed to spawn vehicle")

      return waitForEntity(vehicle)
   end

   if not vx.requestModel(model) then
      return nil
   end

   local vehicle = createVehicle()
   return vehicle
end

return vx.createVehicle
