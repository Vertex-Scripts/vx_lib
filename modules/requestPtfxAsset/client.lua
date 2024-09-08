---@param asset string
---@return string?
function vx.requestPtfxAsset(asset)
   if HasNamedPtfxAssetLoaded(assetName) then
      return asset
   end

   RequestNamedPtfxAsset(assetName)
   while not HasNamedPtfxAssetLoaded(assetName) do
      Citizen.Wait(0)
   end

   return asset
end

return vx.requestPtfxAsset
