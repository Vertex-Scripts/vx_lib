--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright (c) 2025 Linden <https://github.com/thelindat/fivem>
]]

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
