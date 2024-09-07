local isServerSide = IsDuplicityVersion()

---@param type number
---@param model string|number
---@param coords vector3
---@param heading number
---@param isNetwork? boolean
---@param bScriptHostPed? boolean
function vx.spawnPed(type, model, coords, heading, isNetwork, bScriptHostPed)
   local function spawnPed()
      return CreatePed(type, model, coords.x, coords.y, coords.z, heading, isServerSide and true or (isNetwork or false),
         bScriptHostPed or false)
   end

   if isServerSide then
      if type(model) == "string" then
         model = joaat(model)
      end

      local ped = spawnPed()
      local promise = promise.new()

      CreateThread(function()
         while not DoesEntityExist(ped) do
            Citizen.Wait(50)
         end

         promise:resolve(ped)
      end)

      return Citizen.Await(promise)
   end

   if not vx.streaming.requestModel(model) then
      return 0
   end

   local ped = spawnPed()
   return ped
end

return vx.spawnPed
