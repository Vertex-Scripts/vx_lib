---@param model string|number
---@param coords vector3
---@param heading? number
---@param isNetwork? boolean
---@param bScriptHostPed? boolean
---@param doorflag? boolean
---@param waitForEntity? boolean Waits for the entity to spawn, defaults to true
function vx.createObject(model, coords, heading, isNetwork, bScriptHostPed, doorflag, waitForEntity)
   isNetwork = isNetwork or false
   doorflag = doorflag or false
   heading = heading or 0.0

   local function createObject()
      return CreateObject(model, coords.x, coords.y, coords.z,
         vx.ternary(vx.context == "server", true, isNetwork), bScriptHostPed or false, doorflag)
   end

   local object = vx.createEntity(createObject, model, waitForEntity)
   return object
end

return vx.createObject
