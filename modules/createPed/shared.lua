local getType = type

---@param type number
---@param model string|number
---@param coords vector3
---@param heading number
---@param isNetwork? boolean
---@param bScriptHostPed? boolean
function vx.createPed(type, model, coords, heading, isNetwork, bScriptHostPed)
   local isServerSide = vx.context == "server"
   local function createPed()
      return CreatePed(type, model, coords.x, coords.y, coords.z, heading, isServerSide and true or (isNetwork or false),
         bScriptHostPed or false)
   end

   if getType(model) == "string" then
      model = joaat(model)
   end

   if isServerSide then
      local ped = createPed()
      vx.waitFor(function()
         if DoesEntityExist(ped) then
            return true
         end
      end, "Failed to spawn ped")

      return ped
   end

   if not vx.requestModel(model) then
      return nil
   end

   local ped = createPed()
   return ped
end

return vx.createPed