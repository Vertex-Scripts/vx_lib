---@class QbTargetOptions
---@field options QbTargetOption[]
---@field distance? number

---@class QbTargetOption
---@field label string
---@field icon? string
---@field action? fun(entity: number)
---@field canInteract? fun(entity: number, distance: number, data: table): boolean

---@class TargetOptions
---@field label string
---@field name string
---@field icon? string
---@field distance? number
---@field items? string|string[]
---@field onSelect fun(data: table)
---@field canInteract fun(data: table): boolean

---@class EntityTargetOptions : TargetOptions
---@field onSelect? fun(data: { entity: number })
---@field canInteract? fun(data: { entity: number }): boolean

vx.target = {}

-------------
-- Options --
-------------

---@param options TargetOptions
local function createOptions_ox(options)
   ---@type OxTargetOption
   return {
      label = options.label,
      icon = options.icon,
      name = options.name,
      distance = options.distance,
      items = options.items,
      canInteract = function(entity)
         if options.canInteract == nil then
            return true
         end

         return options.canInteract({
            entity = entity
         })
      end,
      onSelect = function(entity)
         if options.onSelect == nil then
            return
         end

         local actualEntity
         if type(actualEntity) == "table" then
            actualEntity = entity.entity
         else
            actualEntity = entity
         end

         options.onSelect({
            entity = entity
         })
      end
   }
end

---@param options TargetOptions
local function createOptions_qb(options)
   local item = nil
   if type(options.items) == "table" then
      vx.logger.warn("QBCore does not support multiple items in a target option, only the first item will be used.")
      item = options.items[1]
   else
      item = options.items
   end

   ---@type QbTargetOptions
   return {
      options = {
         {
            label = options.label,
            icon = options.icon,
            item = item,
            canInteract = function(entity)
               return options.canInteract({
                  entity = entity,
               })
            end,
            action = function(entity)
               options.onSelect({
                  entity = entity
               })
            end
         }
      },
      distance = options.distance
   }
end

---@param options TargetOptions | TargetOptions[]
local function convertOptions(options)
   local caller = vx.caller.createTargetCaller({
      ["ox_target"] = createOptions_ox,
      ["qb-target"] = createOptions_qb,
   })

   if #options > 0 then
      local result = {}
      for _, option in pairs(options) do
         table.insert(result, caller(option))
      end

      return result
   end

   return caller(options)
end

---------------
-- Functions --
---------------

---@param options EntityTargetOptions
function vx.target.addGlobalVehicle(options)
   local targetOptions = convertOptions(options)
   local caller = vx.caller.createTargetCaller({
      ["ox_target"] = function() exports.ox_target:addGlobalVehicle(targetOptions) end,
      ["qb-target"] = function() exports["qb-target"]:AddGlobalVehicle(targetOptions) end,
   })

   caller()
   return targetOptions
end

---@param options OxTargetEntity | QbTargetOption
function vx.target.removeGlobalVehicle(options)
   local caller = vx.caller.createTargetCaller({
      ["ox_target"] = function() exports.ox_target:removeGlobalVehicle(options.name) end,
      ["qb-target"] = function() exports["qb-target"]:RemoveGlobalVehicle(options.label) end,
   })

   caller(options)
end

---@param options EntityTargetOptions
function vx.target.addGlobalPlayer(options)
   local targetOptions = convertOptions(options)
   local caller = vx.caller.createTargetCaller({
      ["ox_target"] = function() exports.ox_target:addGlobalPlayer(targetOptions) end,
      ["qb-target"] = function() exports["qb-target"]:AddGlobalPlayer(targetOptions) end,
   })

   caller()
   return targetOptions
end

---@param options OxTargetEntity | QbTargetOption
function vx.target.removeGlobalPlayer(options)
   local caller = vx.caller.createTargetCaller({
      ["ox_target"] = function() exports.ox_target:removeGlobalPlayer(options.name) end,
      ["qb-target"] = function() exports["qb-target"]:RemoveGlobalPlayer(options.label) end,
   })

   caller()
end

---@param options EntityTargetOptions
function vx.target.addGlobalPed(options)
   local targetOptions = convertOptions(options)
   local caller = vx.caller.createTargetCaller({
      ["ox_target"] = function() exports.ox_target:addGlobalPed(targetOptions) end,
      ["qb-target"] = function() exports["qb-target"]:AddGlobalPed(targetOptions) end,
   })

   caller()
   return targetOptions
end

---@param options OxTargetEntity | QbTargetOption
function vx.target.removeGlobalPed(options)
   local caller = vx.caller.createTargetCaller({
      ["ox_target"] = function() exports.ox_target:removeGlobalPed(options.name) end,
      ["qb-target"] = function() exports["qb-target"]:RemoveGlobalPed(options.label) end,
   })

   caller()
end

---@param entities number|number[]
---@param options EntityTargetOptions
function vx.target.addLocalEntity(entities, options)
   local targetOptions = convertOptions(options)
   local caller = vx.caller.createTargetCaller({
      ["ox_target"] = function() exports.ox_target:addLocalEntity(entities, targetOptions) end,
      -- ["qb-target"] = function () end,
   })

   caller()
   return targetOptions
end

---@param entities number|number[]
---@param options EntityTargetOptions
function vx.target.removeLocalEntity(entities, options)
   local targetOptions = convertOptions(options)
   local caller = vx.caller.createTargetCaller({
      ["ox_target"] = function() exports.ox_target:removeLocalEntity(entities, options.name) end,
      -- ["qb-target"] = function () end,
   })

   caller()
   return targetOptions
end

---@param models string|string[]
---@param options TargetOptions
function vx.target.addModel(models, options)
   local targetOptions = convertOptions(options)
   local caller = vx.caller.createTargetCaller({
      ["ox_target"] = function() exports.ox_target:addModel(models, targetOptions) end,
      ["qb-target"] = function()
         targetOptions.models = models
         exports["qb-target"]:AddTargetModel(models, targetOptions)
      end,
   })

   caller()
   return targetOptions
end

---@param options EntityTargetOptions
function vx.target.removeModel(options)
   local caller = vx.caller.createTargetCaller({
      ["ox_target"] = function() exports.ox_target:removeModel(options.name) end,
      ["qb-target"] = function() exports["qb-target"]:RemoveTargetModel(options.models, options.label) end,
   })

   caller(options)
end

return vx.target
