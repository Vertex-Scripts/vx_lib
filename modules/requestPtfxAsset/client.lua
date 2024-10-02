---@param asset string
---@param timeout? number
---@return string?
function vx.requestPtfxAsset(asset, timeout)
   if HasNamedPtfxAssetLoaded(assetName) then
      return asset
   end

   vx.typeCheck("asset", asset, "string")
   return vx.streamingRequest(RequestNamedPtfxAsset, HasNamedPtfxAssetLoaded, "ptfxAsset", asset, timeout)
end

return vx.requestPtfxAsset
