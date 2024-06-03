---@param type number
---@param model string|number
---@param coords vector3
---@param heading number
---@param isNetwork? boolean
---@param bScriptHostPed? boolean
function vx.spawnPed(type, model, coords, heading, isNetwork, bScriptHostPed)
   vx.requestModel(model)

   local ped = CreatePed(type, model, coords.x, coords.y, coords.z, heading, isNetwork or false, bScriptHostPed or false)
   return ped
end

return vx.spawnPed
