vx.caller = {}

local cachedInventory = nil
local cachedTarget = nil

-- TODO: Extract those in the resource
local inventoryResourceMap = {
   ox_inventory = "ox_inventory",
   qb_inventory = "qb_inventory",
   es_extended = "es_extended",
   qs_inventory = "qs_inventory"
}

local targetResourceMap = {
   ox_target = "ox_target",
   qb_target = "qb_target",
   qtarget = "qtarget"
}

local function getResourceName(system, map)
   return map[system]
end

local function isResourceStarted(resourceName)
   local state = GetResourceState(resourceName)
   return state == "started"
end

local function getSystem(system, map)
   if system ~= "auto" then
      local resourceName = getResourceName(system, map)
      if not isResourceStarted(resourceName) then
         error(("Resource '%s' is not started"):format(system))
      end
      return system
   end

   for sys, resourceName in pairs(map) do
      if isResourceStarted(resourceName) then
         return sys
      end
   end

   return nil
end

function vx.caller.initialize()
   if not cachedInventory then vx.caller.getInventory() end
   if not cachedTarget then vx.caller.getTarget() end
end

function vx.caller.getInventory()
   if cachedInventory then return cachedInventory end

   local inventory = getSystem(vx.config.inventory, inventoryResourceMap)
   cachedInventory = inventory

   return inventory
end

function vx.caller.getTarget()
   if cachedTarget then return cachedTarget end

   local target = getSystem(vx.config.target, targetResourceMap)
   if isResourceStarted("ox_target") then
      target = "ox_target"
   end

   vx.logger.debug("Detected target", target)
   cachedTarget = target

   return target
end

function vx.caller.isResourceStarted(resourceName)
   return isResourceStarted(resourceName)
end

function vx.caller.getFramework()
   return vx.framework
end

local function createCaller(systemGetter, functions)
   vx.caller.initialize()

   local system = systemGetter()
   local func = functions[system]

   if not func then
      error(("System '%s' is not supported"):format(system))
   end

   return func, system
end

function vx.caller.createFrameworkCaller(functions)
   return createCaller(vx.caller.getFramework, functions)
end

function vx.caller.createInventoryCaller(functions)
   return createCaller(vx.caller.getInventory, functions)
end

function vx.caller.createTargetCaller(functions)
   return createCaller(vx.caller.getTarget, functions)
end

return vx.caller
