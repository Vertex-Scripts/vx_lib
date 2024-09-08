local context = IsDuplicityVersion() and "server" or "client"
local currentResourceName = GetCurrentResourceName()

local frameworkSystem = GetConvar("vx:framework", "auto")
local inventorySystem = GetConvar("vx:inventory", "auto")
local targetSystem = GetConvar("vx:target", "auto")

local frameworkResourceMap = {
   primary = {
      ["esx"] = "es_extended",
      ["qb"] = "qb-core"
   },
   secondary = {}
}

local inventoryResourceMap = {
   primary = {
      ["ox_inventory"] = "ox_inventory",
      ["qs_inventory"] = "qs_inventory",
   },
   secondary = {
      ["es_extended"] = "es_extended",
      ["qb-inventory"] = "qb-inventory",
   }
}

local targetResourceMap = {
   primary = {
      ["ox_target"] = "ox_target",
   },
   secondary = {
      ["qb-target"] = "qb-target",
      ["qtarget"] = "qtarget"
   }
}

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

---@param resourceName string
---@param expectedState "missing" | "started" | "stopped" | "starting" | "stopping"
local function isResourceState(resourceName, expectedState)
   local state = GetResourceState(resourceName)
   return state == expectedState
end

local function doesResourceExist(resourceName)
   return not isResourceState(resourceName, "missing")
end

local function isResourceStarted(resourceName)
   return isResourceState(resourceName, "started")
end

---@param map? table<any, any>
local function logLibrary(type, value, map)
   local isStarted = map and isResourceStarted(map[value]) or true
   if context == "server" then
      vx.print.info(("Using %s: ^2%s ^1%s^0"):format(type, value, not isStarted and "(Not started)" or ""))
   end
end

local function getLibrary(type, value, maps)
   function validResourcesInMap(map)
      for system, resourceName in pairs(map) do
         if doesResourceExist(resourceName) then
            return system
         end
      end
   end

   function findLibrary()
      if value ~= "auto" then
         local resourceName = maps.primary[value] or maps.secondary[value]
         if not doesResourceExist(resourceName) then
            error(("Resource '%s' does not exist"):format(value))
         end

         return value
      end

      local autoDetectedResource = validResourcesInMap(maps.primary) or validResourcesInMap(maps.secondary)
      if autoDetectedResource then
         return autoDetectedResource
      end
   end

   local result = findLibrary()
   if not result then
      logLibrary(type, "None")
      return
   end

   logLibrary(type, result, map)
   return result
end

local function initializeFramework(framework)
   local frameworkResourceName = frameworkResourceMap.primary[framework] or frameworkResourceMap.secondary[framework]
   if framework == "esx" then
      ESX = exports[frameworkResourceName]:getSharedObject()
   elseif framework == "qb" then
      QBCore = exports[frameworkResourceName]:GetCoreObject()

      RegisterNetEvent(("QBCore:%s:UpdateObject"):format(context), function()
         QBCore = exports[frameworkResourceName]:GetCoreObject()
      end)
   end
end

local framework = getLibrary("framework", frameworkSystem, frameworkResourceMap)
local inventory = getLibrary("inventory", inventorySystem, inventoryResourceMap)
local target = getLibrary("target", targetSystem, targetResourceMap)

initializeFramework(framework)

if doesResourceExist("ox_lib") then
   local oxInit = LoadResourceFile("ox_lib", "init.lua")
   local loadOx, err = load(oxInit)
   if not loadOx or err then
      vx.print.info(("Failed to load ox_lib (%s)"):format(err))
   else
      loadOx()
      if context == "server" then
         vx.print.info("Successfully loaded ox_lib")
      end
   end
end

function vx.getFramework() return framework end

function vx.getInventory() return inventory end

function vx.getTarget() return target end
