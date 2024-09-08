---@param dict string
---@param timeout number?
---@return string
function vx.requestAnimDict(dict, timeout)
   if HasAnimDictLoaded(animDict) then
      return dict
   end

   if not DoesAnimDictExist(animDict) then
      error(("attempted to load invalid animDict '%s'"):format(animDict))
   end

   vx.typeCheck("animDict", animDict, "string")
   return vx.streamingRequest(RequestAnimDict, HasAnimDictLoaded, "animDict", animDict, timeout)
end

return vx.requestAnimDict
