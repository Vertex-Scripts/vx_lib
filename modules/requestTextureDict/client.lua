---@param dict string
---@return string?
function vx.requestTextureDict(dict)
   if HasStreamedTextureDictLoaded(dict) then
      return dict
   end

   RequestStreamedTextureDict(dict, false)
   while not HasStreamedTextureDictLoaded(dict) do
      Citizen.Wait(0)
   end

   return dict
end

return vx.requestTextureDict
