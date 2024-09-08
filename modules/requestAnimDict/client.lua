---@param dict string
---@return string
function vx.requestAnimDict(dict)
   if HasAnimDictLoaded(animDict) then
      return dict
   end

   RequestAnimDict(animDict)
   while not HasAnimDictLoaded(animDict) do
      Citizen.Wait(0)
   end

   return dict
end

return vx.requestAnimDict
