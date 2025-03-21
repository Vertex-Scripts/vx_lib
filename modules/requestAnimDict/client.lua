--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright (c) 2025 Linden <https://github.com/thelindat/fivem>
]]

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
