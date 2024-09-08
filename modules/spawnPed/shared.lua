local isServerSide = IsDuplicityVersion()
local getType = type

local function waitForEntity(entity)
   while not DoesEntityExist(entity) do
      Citizen.Wait(50)
   end
end

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

   if getType(model) == "string" then
      model = joaat(model)
   end

   if isServerSide then
      local ped = spawnPed()
      return waitForEntity(ped)
   end

   if not vx.requestModel(model) then
      return nil
   end

   local ped = spawnPed()
   return ped
end

return vx.spawnPed
