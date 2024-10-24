--- Used internally
---@param createEntity fun(): number
---@param model string|number
---@param waitForEntity? boolean Waits for the entity to spawn, defaults to true
function vx.createEntity(createEntity, model, waitForEntity)
   waitForEntity = vx.ternary(waitForEntity == nil, true, false)

   if type(model) == "string" then
      model = joaat(model)
   end

   if vx.context == "server" then
      local entity = createEntity()
      if waitForEntity then
         vx.waitFor(function()
            if DoesEntityExist(entity) then
               return true
            end
         end, "Failed to spawn entity")
      end

      return entity
   end

   if not vx.requestModel(model) then
      return 0
   end

   local entity = createEntity()
   return entity
end

return vx.createEntity
