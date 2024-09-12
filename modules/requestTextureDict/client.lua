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
