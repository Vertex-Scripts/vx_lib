---@param asset string
---@return string?
function vx.requestPtfxAsset(asset)
   if HasNamedPtfxAssetLoaded(assetName) then
      return asset
   end

   vx.typeCheck("asset", asset, "string")
   return vx.streamingRequest(RequestNamedPtfxAsset, HasNamedPtfxAssetLoaded, "ptfxAsset", asset, timeout)
end

return vx.requestPtfxAsset
