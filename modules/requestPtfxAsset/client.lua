--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright (c) 2025 Linden <https://github.com/thelindat/fivem>
]]

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
