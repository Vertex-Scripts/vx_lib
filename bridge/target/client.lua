vx.target = {}

local oxTarget = vx.targetResource == "ox_target" and exports.ox_target or nil
local qbTarget = vx.targetResource == "qb-target" and exports["qb-target"] or nil

---@class QbTargetOptions
---@field options QbTargetOption[]
---@field distance? number

---@class QbTargetOption
---@field label string
---@field icon? string
---@field action? fun(data: table)
---@field canInteract? fun(data: table): boolean

---@class TargetOptions
---@field label string
---@field icon? string
---@field distance? number
---@field item? string
---@field job? string
---@field onSelect fun(data: table)
---@field canInteract fun(data: table): boolean

---@class EntityTargetOptions : TargetOptions
---@field onSelect? fun(entity: number)
---@field canInteract? fun(entity: number): boolean

---@param option TargetOptions
local function convertOption_ox(option)
   ---@type OxTargetOption
   local transformedOptions = {
      label = option.label,
      name = option.label,
      distance = option.distance,
      icon = option.icon,
      items = option.item,
      groups = option.job,
      canInteract = option.canInteract,
      onSelect = option.onSelect
   }

   return transformedOptions
end

---@param option TargetOptions
local function convertOption_qb(option)
   ---@type QbTargetOption
   local transformedOptions = {
      label = option.label,
      icon = option.icon,
      item = option.item,
      job = option.job,
      action = option.onSelect,
      canInteract = option.canInteract
   }

   return transformedOptions
end

---@param options TargetOptions|TargetOptions[]
local function transformOptions(options)
   local convertFunc = oxTarget and convertOption_ox or convertOption_qb
   if table.type(options) == "array" then
      local optionsArray = vx.array:new(table.unpack(options))
      return optionsArray:map(convertFunc)
   end

   return vx.array:new(convertFunc(options))
end

local function createQbTargetParams(transformedOptions)
   return {
      options = transformedOptions,
      distance = transformedOptions[1].distance or 2.0
   }
end

local function addTarget(oxExport, qbExport, options, ...)
   local transformedOptions = transformOptions(options)
   local arguments = vx.array:new()
   if ... then
      arguments:push(...)
   end

   if oxTarget then
      arguments:push(transformedOptions)
   elseif qbTarget then
      arguments:push(createQbTargetParams(transformedOptions))
   end

   local target = oxTarget or qbTarget
   local export = oxTarget and oxExport or qbExport
   if target then
      target[export](target, table.unpack(arguments))
   end

   local targetIdentifiers = transformedOptions:map(function(option) return option.label end)
   return targetIdentifiers
end

local function removeTarget(oxExport, qbExport, ...)
   if oxTarget then
      oxTarget[oxExport](oxTarget, ...)
   elseif qbTarget then
      qbTarget[qbExport](qbTarget, ...)
   end
end

---@param options EntityTargetOptions|EntityTargetOptions[]
function vx.target.addGlobalVehicle(options)
   return addTarget("addGlobalVehicle", "AddGlobalVehicle", options)
end

-- TODO: Test with ox
---@param labels string|string[]
function vx.target.removeGlobalVehicle(labels)
   return removeTarget("removeGlobalVehicle", "RemoveGlobalVehicle", labels)
end

---@param options EntityTargetOptions
function vx.target.addGlobalPlayer(options)
   return addTarget("addGlobalPlayer", "AddGlobalPlayer", options)
end

-- TODO: Test with ox and qb
---@param options OxTargetEntity | QbTargetOption
function vx.target.removeGlobalPlayer(options)
   return removeTarget("removeGlobalPlayer", "RemoveGlobalPlayer", options)
end

---@param options EntityTargetOptions|EntityTargetOptions[]
function vx.target.addGlobalPed(options)
   return addTarget("addGlobalPed", "AddGlobalPed", options)
end

---@param identifiers string|string[]
function vx.target.removeGlobalPed(identifiers)
   return removeTarget("removeGlobalPed", "RemoveGlobalPed", identifiers)
end

---@param entities number|number[]
---@param options EntityTargetOptions
function vx.target.addLocalEntity(entities, options)
   return addTarget("addLocalEntity", "AddTargetEntity", options, entities)
end

---@param entities number|number[]
---@param options EntityTargetOptions
function vx.target.removeLocalEntity(entities, options)
   return removeTarget("removeLocalEntity", "RemoveTargetEntity", entities, options)
end

---@param models string|string[]
---@param options TargetOptions
function vx.target.addGlobalModel(models, options)
   return addTarget("addModel", "AddTargetModel", options, models)
end

-- TODO: Test with qb
---@param models string|string[]
---@param identifiers string|string[]
function vx.target.removeGlobalModel(models, identifiers)
   return removeTarget("removeModel", "RemoveTargetModel",
      oxTarget and models or identifiers,
      oxTarget and identifiers or models)
end

return vx.target
