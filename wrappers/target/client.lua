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

-- Vehicle --

local function addGlobalVehicle_ox(options)
   exports.ox_target:addGlobalVehicle(options)
end

local function addGlobalVehicle_qb(options)
   exports["qb-target"]:AddGlobalVehicle(options)
end

---@param options EntityTargetOptions
function vx.target.addGlobalVehicle(options)
   local targetOptions = convertOptions(options)
   local caller = vx.caller.createTargetCaller({
      ["ox_target"] = addGlobalVehicle_ox,
      ["qb-target"] = addGlobalVehicle_qb,
   })

   caller(targetOptions)
   return targetOptions
end

---@param options OxTargetEntity
local function removeGlobalVehicle_ox(options)
   exports.ox_target:removeGlobalVehicle(options.name)
end

---@param options QbTargetOption
local function removeGlobalVehicle_qb(options)
   exports["qb-target"]:RemoveGlobalVehicle(options.label)
end

---@param options OxTargetEntity | QbTargetOption
function vx.target.removeGlobalVehicle(options)
   local caller = vx.caller.createTargetCaller({
      ["ox_target"] = removeGlobalVehicle_ox,
      ["qb-target"] = removeGlobalVehicle_qb,
   })

   caller(options)
end

-- Player --

local function addGlobalPlayer_ox(options)
   exports.ox_target:addGlobalPlayer(options)
end

local function addGlobalPlayer_qb(options)
   exports["qb-target"]:AddGlobalPlayer(options)
end

---@param options EntityTargetOptions
function vx.target.addGlobalPlayer(options)
   local targetOptions = convertOptions(options)
   local caller = vx.caller.createTargetCaller({
      ["ox_target"] = addGlobalPlayer_ox,
      ["qb-target"] = addGlobalPlayer_qb,
   })

   caller(targetOptions)
   return targetOptions
end

local function removeGlobalPlayer_ox(options)
   exports.ox_target:removeGlobalPlayer(options.name)
end

local function removeGlobalPlayer_qb(options)
   exports["qb-target"]:RemoveGlobalPlayer(options.label)
end

---@param options EntityTargetOptions
function vx.target.removeGlobalPlayer(options)
   local targetOptions = convertOptions(options)
   local caller = vx.caller.createTargetCaller({
      ["ox_target"] = removeGlobalPlayer_ox,
      ["qb-target"] = removeGlobalPlayer_qb,
   })

   caller(targetOptions)
   return targetOptions
end

-- Ped --

local function addGlobalPed_ox(options)
   exports.ox_target:addGlobalPed(options)
end

local function addGlobalPed_qb(options)
   exports["qb-target"]:AddGlobalPed(options)
end

---@param options EntityTargetOptions
function vx.target.addGlobalPed(options)
   local targetOptions = convertOptions(options)
   local caller = vx.caller.createTargetCaller({
      ["ox_target"] = addGlobalPed_ox,
      ["qb-target"] = addGlobalPed_qb,
   })

   caller(targetOptions)
   return targetOptions
end

local function removeGlobalPed_ox(options)
   exports.ox_target:removeGlobalPed(options.name)
end

local function removeGlobalPed_qb(options)
   exports["qb-target"]:RemoveGlobalPed(options.label)
end

---@param options EntityTargetOptions
function vx.target.removeGlobalPed(options)
   local targetOptions = convertOptions(options)
   local caller = vx.caller.createTargetCaller({
      ["ox_target"] = removeGlobalPed_ox,
      ["qb-target"] = removeGlobalPed_qb,
   })

   caller(targetOptions)
   return targetOptions
end

function addLocalEntity_ox(entities, options)
   exports.ox_target:addLocalEntity(entities, options)
end

-- TODO
-- function addLocalEntity_qb(entities, options)
--    exports["qb-target"]:AddLocalEntity(entities, options)
-- end

---@param entities number|number[]
---@param options EntityTargetOptions
function vx.target.addLocalEntity(entities, options)
   local targetOptions = convertOptions(options)
   local caller = vx.caller.createTargetCaller({
      ["ox_target"] = addLocalEntity_ox,
      -- ["qb-target"] = addLocalEntity_qb,
   })

   caller(entities, targetOptions)
   return targetOptions
end

-- Models --

local function addModel_ox(models, options)
   exports.ox_target:addModel(models, options)
end

local function addModel_qb(models, options)
   options.models = models
   exports["qb-target"]:AddTargetModel(models, options)
end

---@param models string|string[]
---@param options TargetOptions
function vx.target.addModel(models, options)
   local targetOptions = convertOptions(options)
   local caller, target = vx.caller.createTargetCaller({
      ["ox_target"] = addModel_ox,
      ["qb-target"] = addModel_qb,
   })

   if target == "qb-target" then
      targetOptions.models = models
   end

   caller(models, targetOptions)
   return targetOptions
end

local function removeModel_ox(options)
   exports.ox_target:removeModel(options.name)
end

local function removeModel_qb(options)
   vx.logger.info(options)
   exports["qb-target"]:RemoveTargetModel(options.models, options.label)
end

---@param options EntityTargetOptions
function vx.target.removeModel(options)
   local caller = vx.caller.createTargetCaller({
      ["ox_target"] = removeModel_ox,
      ["qb-target"] = removeModel_qb,
   })

   caller(options)
end

return vx.target
