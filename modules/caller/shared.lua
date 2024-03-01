cfx.caller = {}

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
function cfx.caller.getSystem(system, map)
   if system ~= "auto" then
      local resourceName = map[system]
      if not cfx.caller.isResourceStarted(resourceName) then
         error(("Resource '%s' is not started"):format(system))
      end

      return system
   end

   for system, resourceName in pairs(map) do
      if cfx.caller.isResourceStarted(resourceName) then
         -- Because ox_target has an alias for qtarget and qb-target
         if cfx.caller.isResourceStarted("ox_target") then
            return "ox_target"
         end

         return system
      end
   end

   return nil
end

function cfx.caller.initialize()
   if not cachedFramework then cfx.caller.getFramework() end
   if not cachedInventory then cfx.caller.getInventory() end
   if not cachedTarget then cfx.caller.getTarget() end
end

function cfx.caller.getFramework()
   if cachedFramework then
      return cachedFramework
   end

   ---@type Framework
   local framework = cfx.caller.getSystem(cfx.config.framework, frameworkResourceMap)
   cfx.caller.initializeFramework(framework)
   cfx.logger.debug("Detected framework", framework)

   return framework
end

function cfx.caller.getInventory()
   if cachedInventory then
      return cachedInventory
   end

   local inventory = cfx.caller.getSystem(cfx.config.inventory, inventoryResourceMap)
   cfx.logger.debug("Detected inventory", inventory)
   cachedInventory = inventory

   return inventory
end

function cfx.caller.getTarget()
   if cachedTarget then
      return cachedTarget
   end

   local target = cfx.caller.getSystem(cfx.config.target, targetResourceMap)
   cfx.logger.debug("Detected target", target)
   cachedTarget = target

   return target
end

---@param framework Framework
function cfx.caller.initializeFramework(framework)
   cachedFramework = framework

   local resourceName = frameworkResourceMap[framework]
   -- cfx.logger.info(("Detected framework: %s (%s)"):format(framework, resourceName))

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

function cfx.caller.isResourceStarted(resourceName)
   local state = GetResourceState(resourceName)
   return state == "started"
end

-- TODO: Make this cleaner :-(

---@generic TFunc : function
---@param functions { [Framework]: TFunc }
---@return TFunc
function cfx.caller.createFrameworkCaller(functions)
   cfx.caller.initialize()

   local framework = cfx.caller.getFramework()
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
function cfx.caller.createInventoryCaller(functions)
   cfx.caller.initialize()

   local inventory = cfx.caller.getInventory()
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
function cfx.caller.createTargetCaller(functions)
   cfx.caller.initialize()

   local target = cfx.caller.getTarget()
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

return cfx.caller
