---@param set string
---@return string
function vx.requestAnimSet(set)
   if HasAnimSetLoaded(animSet) then
      return set
   end

   RequestAnimSet(animSet)
   while not HasAnimSetLoaded(animSet) do
      Citizen.Wait(0)
   end

   return set
end

return vx.requestAnimSet
