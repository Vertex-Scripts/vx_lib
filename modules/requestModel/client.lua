-- TODO: Timeout

---@param model number | string
---@return number? model
function vx.requestModel(model)
   if not tonumber(model) then
      model = joaat(model)
   end

   ---@cast model -string
   if HasModelLoaded(model) then return model end

   if not IsModelValid(model) then
      return error(("attempted to load invalid model '%s'"):format(model))
   end

   RequestModel(model)
   while not HasModelLoaded(model) do
      Wait(0)
   end
end

return vx.requestModel
