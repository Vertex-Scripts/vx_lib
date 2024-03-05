vx.caller = {}

ESX = nil
QBCore = nil

local cachedFramework = nil
local cachedInventory = nil
local cachedTarget = nil

---@type { [Framework]: string }
local frameworkResourceMap = {
   ["ESX"] = "es_extended",
   ["QB"] = "qb-core"
}

---@type { [InventorySystem]: string }
local inventoryResourceMap = {
   ["ox_inventory"] = "ox_inventory",
   ["qb-inventory"] = "qb-inventory",
   ["es_extended"] = "es_extended",
   ["qs-inventory"] = "qs-inventory"
}

---@type { [TargetSystem]: string }
local targetResourceMap = {
   ["ox_target"] = "ox_target",
   ["qb-target"] = "qb-target",
   ["qtarget"] = "qtarget"
}

---@generic TSystem
---@param system TSystem
---@return TSystem
function vx.caller.getSystem(system, map)
   if system ~= "auto" then
      local resourceName = map[system]
      if not vx.caller.isResourceStarted(resourceName) then
         error(("Resource '%s' is not started"):format(system))
      end

      return system
   end

   for system, resourceName in pairs(map) do
      if vx.caller.isResourceStarted(resourceName) then
         -- Because ox_target has an alias for qtarget and qb-target
         return system
      end
   end

   return nil
end

function vx.caller.initialize()
   if not cachedFramework then vx.caller.getFramework() end
   if not cachedInventory then vx.caller.getInventory() end
   if not cachedTarget then vx.caller.getTarget() end
end

function vx.caller.getFramework()
   if cachedFramework then
      return cachedFramework
   end

   ---@type Framework
   local framework = vx.caller.getSystem(vx.config.framework, frameworkResourceMap)
   vx.caller.initializeFramework(framework)
   vx.logger.debug("Detected framework", framework)

   return framework
end

function vx.caller.getInventory()
   if cachedInventory then
      return cachedInventory
   end

   local inventory = vx.caller.getSystem(vx.config.inventory, inventoryResourceMap)
   vx.logger.debug("Detected inventory", inventory)
   cachedInventory = inventory

   return inventory
end

function vx.caller.getTarget()
   if cachedTarget then
      return cachedTarget
   end

   local target = vx.caller.getSystem(vx.config.target, targetResourceMap)
   if vx.caller.isResourceStarted("ox_target") then
      target = "ox_target"
   end

   vx.logger.debug("Detected target", target)
   cachedTarget = target

   return target
end

---@param framework Framework
function vx.caller.initializeFramework(framework)
   cachedFramework = framework

   local resourceName = frameworkResourceMap[framework]
   -- vx.logger.info(("Detected framework: %s (%s)"):format(framework, resourceName))

   if framework == "ESX" then
      ESX = exports[resourceName]:getSharedObject()
   elseif framework == "QB" then
      QBCore = exports[resourceName]:GetCoreObject()

      local context = IsDuplicityVersion() and "server" or "client"
      RegisterNetEvent(("QBCore:%s:UpdateObject"):format(context), function()
         QBCore = exports[resourceName]:GetCoreObject()
      end)
   end
end

function vx.caller.isResourceStarted(resourceName)
   local state = GetResourceState(resourceName)
   return state == "started"
end

-- TODO: Make this cleaner :-(

---@generic TFunc : function
---@param functions { [Framework]: TFunc }
---@return TFunc
function vx.caller.createFrameworkCaller(functions)
   vx.caller.initialize()

   local framework = vx.caller.getFramework()
   for targetFramework, targetFunc in pairs(functions) do
      if targetFramework == framework then
         return targetFunc
      end
   end

   return error(("Framework '%s' is not supported"):format(framework))
end

---@generic TFunc : function
---@param functions { [InventorySystem]: TFunc }
---@return TFunc
function vx.caller.createInventoryCaller(functions)
   vx.caller.initialize()

   local inventory = vx.caller.getInventory()
   local func = nil

   for targetInventory, targetFunc in pairs(functions) do
      if targetInventory == inventory then
         func = targetFunc
         break
      end
   end

   if func == nil then
      error(("Inventory '%s' is not supported"):format(inventory))
   end

   return func
end

---@generic TFunc : function
---@param functions { [TargetSystem]: TFunc }
---@return TFunc, TargetSystem
function vx.caller.createTargetCaller(functions)
   vx.caller.initialize()

   local target = vx.caller.getTarget()
   local func = nil
   local system

   for targetTarget, targetFunc in pairs(functions) do
      if targetTarget == target then
         func = targetFunc
         system = targetTarget
         break
      end
   end

   if func == nil then
      error(("Inventory '%s' is not supported"):format(target))
   end

   return func, system
end

return vx.caller
