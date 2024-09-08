local isServerSide = IsDuplicityVersion()

local function waitForEntity(entity)
   while not DoesEntityExist(entity) do
      Citizen.Wait(50)
   end
end

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
      return waitForEntity(vehicle)
   end

   if not vx.requestModel(model) then
      return nil
   end

   local vehicle = createVehicle()
   return vehicle
end

return vx.createVehicle
