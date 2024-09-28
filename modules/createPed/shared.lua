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

   local ped = vx.createEntity(createPed, model)
   return ped
end

return vx.createPed
