local isServerSide = IsDuplicityVersion()

---@param model string|number
---@param coords vector3
---@param heading number
---@param isNetwork? boolean
---@param netMissionEntity? boolean
function vx.createVehicle(model, coords, heading, isNetwork, netMissionEntity)
   if type(model) == "string" then
      model = joaat(model)
   end

   local function createVehicle()
      return CreateVehicle(model, coords.x, coords.y, coords.z, heading, isNetwork or false, netMissionEntity or false)
   end

   if isServerSide then
      local vehicle = createVehicle()
      local promise = promise.new()

      CreateThread(function()
         while not DoesEntityExist(vehicle) do
            Citizen.Wait(50)
         end

         promise:resolve(NetworkGetNetworkIdFromEntity(vehicle))
      end)

      return Citizen.Await(promise)
   end

   if not vx.streaming.requestModel(model) then
      return 0
   end

   local ped = createVehicle()
   return ped
end

return vx.createVehicle