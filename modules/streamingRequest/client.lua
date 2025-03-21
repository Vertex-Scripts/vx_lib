--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright (c) 2025 Linden <https://github.com/thelindat/fivem>
]]

---@async
---@generic T : string | number
---@param request function
---@param hasLoaded function
---@param assetType string
---@param asset T
---@param timeout? number
---@param ... any
function vx.streamingRequest(request, hasLoaded, assetType, asset, timeout, ...)
   if hasLoaded(asset) then
      return asset
   end

   request(asset, ...)
   vx.print.verbose(("Loading %s '%s' - remember to release it when done."):format(assetType, asset))

   return vx.waitFor(function()
         if hasLoaded(asset) then
            return
                asset
         end
      end,
      ("failed to load %s '%s' - this is likely caused by unreleased assets"):format(assetType, asset),
      timeout or 10000)
end

return vx.streamingRequest
