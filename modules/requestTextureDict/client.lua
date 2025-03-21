--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright (c) 2025 Linden <https://github.com/thelindat/fivem>
]]

---@param dict string
---@param timeout number?
---@return string?
function vx.requestTextureDict(dict, timeout)
   if HasStreamedTextureDictLoaded(dict) then
      return dict
   end

   vx.typeCheck("dict", dict, "string")
   return vx.streamingRequest(RequestStreamedTextureDict, HasStreamedTextureDictLoaded, "textureDict", dict, timeout)
end

return vx.requestTextureDict
