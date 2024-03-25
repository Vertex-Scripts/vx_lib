vx.streaming = {}

---@param model number | string
---@return number?
function vx.streaming.requestModel(model)
   model = tonumber(model) or joaat(model)

   ---@cast model -string
   if HasModelLoaded(model) then
      return model
   end

   if not IsModelValid(model) then
      return error(("attempted to load invalid model '%s'"):format(model))
   end

   RequestModel(model)
   while not HasModelLoaded(model) do
      Citizen.Wait(0)
   end

   return model
end

return vx.streaming
