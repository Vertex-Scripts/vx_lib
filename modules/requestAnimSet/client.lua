---@param animSet string
---@param timeout number?
---@return string
function vx.requestAnimSet(animSet, timeout)
   if HasAnimSetLoaded(animSet) then
      return set
   end

   vx.typeCheck("animSet", animSet, "string")
   return vx.streamingRequest(RequestAnimSet, HasAnimSetLoaded, "animSet", animSet, timeout)
end

return vx.requestAnimSet
