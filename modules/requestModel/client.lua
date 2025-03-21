--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright (c) 2025 Linden <https://github.com/thelindat/fivem>
]]

---@param model number | string
---@param timeout? number
---@return number?
function vx.requestModel(model, timeout)
   if type(model) ~= "number" then model = joaat(model) end
   if HasModelLoaded(model) then
      return model
   end

   if not IsModelValid(model) and not IsModelInCdimage(model) then
      return error(("attempted to load invalid model '%s'"):format(model))
   end

   return vx.streamingRequest(RequestModel, HasModelLoaded, "model", model, timeout)
end

return vx.requestModel
