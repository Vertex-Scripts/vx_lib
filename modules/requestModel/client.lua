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
