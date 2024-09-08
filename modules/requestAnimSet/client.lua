---@param set string
---@param timeout number?
---@return string
function vx.requestAnimSet(set, timeout)
   if HasAnimSetLoaded(animSet) then
      return set
   end

   return vx.streamingRequest(RequestAnimSet, HasAnimSetLoaded, "animSet", set, timeout)
end

return vx.requestAnimSet
