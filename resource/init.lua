local context = IsDuplicityVersion() and "server" or "client"

local frameworkSystem = GetConvar("vx:framework", "auto")
local inventorySystem = GetConvar("vx:inventory", "auto")
local targetSystem = GetConvar("vx:target", "auto")

local frameworkResourceMap = {
   ESX = "es_extended",
   QB = "qb-core"
}

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

local debug_getinfo = debug.getinfo

function noop() end

vx = setmetatable({
   name = 'vx_lib',
   context = context
}, {
   __newindex = function(self, key, fn)
      rawset(self, key, fn)

      if debug_getinfo(2, 'S').short_src:find('@vx_lib/resource') then
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

         rawset(self, key, fn() or noop)

         return self[key]
      end
   end
})

function isResourceStarted(resourceName)
   local state = GetResourceState(resourceName)
   return state == "started"
end

function getLibrary(value, map)
   if value ~= "auto" then
      local resourceName = map[value]
      if not isResourceStarted(resourceName) then
         error(("Resource '%s' is not started"):format(value))
      end

      return value
   end

   for system, resourceName in pairs(map) do
      if isResourceStarted(resourceName) then
         return system
      end
   end

   return nil
end

local function initializeFramework(framework)
   local frameworkResourceName = frameworkResourceMap[framework]

   if framework == "ESX" then
      ESX = exports[frameworkResourceName]:getSharedObject()
   elseif framework == "QB" then
      QBCore = exports[frameworkResourceName]:GetCoreObject()

      RegisterNetEvent(("QBCore:%s:UpdateObject"):format(context), function()
         QBCore = exports[frameworkResourceName]:GetCoreObject()
      end)
   end
end

local framework = getLibrary(frameworkSystem, frameworkResourceMap) or error("Failed to auto detect framework")
local inventory = getLibrary(inventorySystem, inventoryResourceMap) or error("Failed to auto detect inventory")
local target = getLibrary(targetSystem, targetResourceMap) or error("Failed to auto detect target")
initializeFramework(framework)

exports("getFramework", function() return framework end)
exports("getInventory", function() return inventory end)
exports("getTarget", function() return target end)

vx.print.info("Using framework", framework)
vx.print.info("Using inventory", inventory)
vx.print.info("Using target", target)
