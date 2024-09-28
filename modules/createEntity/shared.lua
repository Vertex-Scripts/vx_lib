--- Used internally
---@param createEntity fun(): any
---@param model string|number
function vx.createEntity(createEntity, model)
   if type(model) == "string" then
      model = joaat(model)
   end

   if vx.context == "server" then
      local entity = createEntity()
      vx.waitFor(function()
         if DoesEntityExist(entity) then
            return true
         end
      end, "Failed to spawn entity")

      return entity
   end

   if not vx.requestModel(model) then
      return nil
   end

   local entity = createEntity()
   return entity
end

return vx.createEntity
