local context = IsDuplicityVersion() and "server" or "client"
local currentResourceName = GetCurrentResourceName()

local frameworkSystem = GetConvar("vx:framework", "auto")
local inventorySystem = GetConvar("vx:inventory", "auto")
local targetSystem = GetConvar("vx:target", "auto")
local notifySystem = GetConvar("vx:notification", "auto")

local frameworkResourceMap = {
   ["esx"] = "es_extended",
   ["qb"] = "qb-core"
}

local inventoryResourceMap = {
   ["es_extended"] = "es_extended",
   ["ox_inventory"] = "ox_inventory",
   ["qb-inventory"] = "qb-inventory",
   ["qs_inventory"] = "qs_inventory"
}

local targetResourceMap = {
   ["ox_target"] = "ox_target",
   ["qb-target"] = "qb-target",
   ["qtarget"] = "qtarget"
}

local notifyMap = { "esx", "qb", "ox", "vx", "custom" }

---@type VxCache
---@diagnostic disable-next-line: missing-fields
local cache = {
   resource = currentResourceName
}

vx = setmetatable({
   name = 'vx_lib',
   context = context,
   cache = cache
}, {
   __newindex = function(self, key, fn)
      rawset(self, key, fn)

      if debug.getinfo(2, 'S').short_src:find('@vx_lib/resource') then
         exports(key, fn)
      end
   end,

   __index = function(self, key)
      local dir = ('modules/%s'):format(key)
      local chunk = LoadResourceFile(self.name, ('%s/%s.lua'):format(dir, self.context))
      local shared = LoadResourceFile(self.name, ('%s/shared.lua'):format(dir))

      if shared then
         chunk = (chunk and ('%s\n%s'):format(shared, chunk)) or shared
      end

      if chunk then
         local fn, err = load(chunk, ('@@vx_lib/%s/%s.lua'):format(key, self.context))

         if not fn or err then
            return error(('\n^1Error importing module (%s): %s^0'):format(dir, err), 3)
         end

         rawset(self, key, fn() or function() end)
         return self[key]
      end
   end
})

local function doesResourceExist(resourceName)
   local state = GetResourceState(resourceName)
   return state ~= "missing"
end

local function isResourceStarted(resourceName)
   local state = GetResourceState(resourceName)
   return state == "started"
end

---@param map? table<any, any>
local function logLibrary(type, value, map)
   local isStarted = map and isResourceStarted(map[value]) or true
   if context == "server" then
      print(("Using %s: ^2%s ^1%s^0"):format(type, value, not isStarted and "(Not started)" or ""))
   end
end

local function getLibrary(type, value, map)
   function findLibrary()
      if value ~= "auto" then
         local resourceName = map[value]
         if not doesResourceExist(resourceName) then
            error(("Resource '%s' does not exist"):format(value))
         end

         return value
      end

      if map == targetResourceMap and doesResourceExist("ox_target") then
         return "ox_target"
      end

      for system, resourceName in pairs(map) do
         if doesResourceExist(resourceName) then
            return system
         end
      end

      error(("Failed to auto detect system for %s"):format(type))
   end

   local result = findLibrary()
   logLibrary(type, result, map)

   return result
end

local function initializeFramework(framework)
   local frameworkResourceName = frameworkResourceMap[framework]

   if framework == "esx" then
      ESX = exports[frameworkResourceName]:getSharedObject()
   elseif framework == "qb" then
      QBCore = exports[frameworkResourceName]:GetCoreObject()

      RegisterNetEvent(("QBCore:%s:UpdateObject"):format(context), function()
         QBCore = exports[frameworkResourceName]:GetCoreObject()
      end)
   end
end

local function isValidNotifySystem(notify)
   for _, ns in pairs(notifyMap) do
      if ns == notify then
         return true
      end
   end

   return false
end

local framework = getLibrary("framework", frameworkSystem, frameworkResourceMap)
local inventory = getLibrary("inventory", inventorySystem, inventoryResourceMap)
local target = getLibrary("target", targetSystem, targetResourceMap)

local notify = notifySystem == "auto" and framework or notifySystem
if not isValidNotifySystem(notify) then
   error(("Invalid notification system in vx:notifySystem expected 'ox', 'esx', 'qb', 'vx' or 'custom' (received %s)")
      :format(notify))
end

logLibrary("notify", notify)
initializeFramework(framework)

function vx.getFramework() return framework end

function vx.getInventory() return inventory end

function vx.getTarget() return target end

function vx.getNotify() return notify end
