local resourceName = GetCurrentResourceName()
local context = IsDuplicityVersion() and "server" or "client"
local export = exports["vx_lib"]

local framework = export:getFramework()
local inventory = export:getInventory()
local target = export:getTarget()

---@cast framework Framework
---@cast inventory InventorySystem
---@cast target TargetSystem

local moduleLoaderFile = LoadResourceFile("vx_lib", "loader.lua")
local loadModuleLoader, err = load(moduleLoaderFile)
if not loadModuleLoader or err then
   error(("Failed to load module loader: %s"):format(err))
end

loadModuleLoader()

local function call(self, index, ...)
   local module = rawget(self, index)
   if not module then
      self[index] = noop
      module = vx_loadModule(self, index)

      if not module then
         local function method(...)
            return export[index](nil, ...)
         end

         if not ... then
            self[index] = method
         end

         return method
      end
   end

   return module
end

local vx = setmetatable({
   name = "vx_lib",
   context = context,
   systems = {
      framework = framework,
      inventory = inventory,
      target = target,
   },
   serverConfig = context == "server" and export:getServerConfig() or {},
}, {
   __index = call,
   __call = call
})

---@type VxCache
vx.cache = setmetatable({
   resource = resourceName
}, {
   __index = context == "client" and function(self, key)
      AddEventHandler(("vx:cache:set:%s"):format(key), function(value)
         self[key] = value
      end)

      local value = export.getFromCache(nil, key)
      if value ~= nil then
         rawset(self, key, value)
      end

      return rawget(self, key)
   end or nil,
})

_ENV.vx = vx
_ENV.require = vx.require

if framework == "es_extended" then
   _ENV.ESX = exports[framework]:getSharedObject()
elseif framework == "qb-core" then
   _ENV.QBCore = exports[framework]:GetCoreObject()

   RegisterNetEvent(("QBCore:%s:UpdateObject"):format(context), function()
      _ENV.QBCore = exports[framework]:GetCoreObject()
   end)
end
