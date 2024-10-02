local context = IsDuplicityVersion() and "server" or "client"
local currentResourceName = GetCurrentResourceName()

local frameworkConvar = GetConvar("vx:framework", "auto")
local inventoryConvar = GetConvar("vx:inventory", "auto")
local targetConvar = GetConvar("vx:target", "auto")

local frameworkResources = {
   "es_extended"
}

local inventoryResources = {
   "ox_inventory",
   "qs_inventory",
   "es_extended",
   "qb-inventory"
}

local targetResources = {
   "ox_target",
   "qb-target",
   "qtarget",
}

---@type VxCache
---@diagnostic disable-next-line: missing-fields
local cache = {
   resource = currentResourceName
}

local function proxyExports(self, key, fn)
   rawset(self, key, fn)

   if debug.getinfo(2, 'S').short_src:find('@vx_lib/resource') then
      exports(key, fn)
   end
end

vx = setmetatable({
   name = "vx_lib",
   context = context,
   cache = cache
}, {
   __index = vx_loadModule,
   __newindex = proxyExports,
})

local function doesResourceExist(resourceName)
   return GetResourceState(resourceName) ~= "missing"
end

local function getLibrary(type, convar, map)
   local function findLibrary()
      for _, resource in pairs(map) do
         if doesResourceExist(resource) then
            return resource
         end
      end
   end

   local result = vx.ternary(convar ~= "auto", convar, findLibrary())
   local isStarted = GetResourceState(result) == "started"
   vx.print.info(("Using %s: ^2%s ^1%s^0"):format(type, result, not isStarted and "(Not started)" or ""))

   return result
end

local function initializeFramework(framework)
   if framework == "es_extended" then
      ESX = exports[framework]:getSharedObject()
   elseif framework == "qb-core" then
      QBCore = exports[framework]:GetCoreObject()

      RegisterNetEvent(("QBCore:%s:UpdateObject"):format(context), function()
         QBCore = exports[framework]:GetCoreObject()
      end)
   end
end

if not LoadResourceFile(vx.name, "web/dist/index.html") then
   error(
      "Failed to load UI, build vx_lib or download the latest release. (https://github.com/Vertex-Scripts/vx_lib)")
end

local framework = getLibrary("framework", frameworkConvar, frameworkResources)
local inventory = getLibrary("inventory", inventoryConvar, inventoryResources)
local target = getLibrary("target", targetConvar, targetResources)
initializeFramework(framework)

if doesResourceExist("ox_lib") then
   local oxInit = LoadResourceFile("ox_lib", "init.lua")
   local loadOx, err = load(oxInit)
   if not loadOx or err then
      vx.print.error(("Failed to load ox_lib (%s)"):format(err))
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
