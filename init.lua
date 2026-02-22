local resourceName = GetCurrentResourceName()
local context = IsDuplicityVersion() and "server" or "client"
local export = exports["vx_lib"]

local moduleLoaderFile = LoadResourceFile("vx_lib", "loader.lua")
local loadModuleLoader, err = load(moduleLoaderFile)
if not loadModuleLoader or err then
   error(("Failed to load module loader: %s"):format(err))
end

loadModuleLoader()

print(("Loaded vx_lib in %s context"):format(context))
local function call(self, index, ...)
   local module = rawget(self, index)

   if not module then
      self[index] = noop
      module = vx_loadModule(self, index)

      if not module then
         local function makeProxy(path)
            return setmetatable({}, {
               __index = function(_, key)
                  return makeProxy(path .. key)
               end,

               __call = function(_, ...)
                  return export[path](nil, ...)
               end
            })
         end

         local proxy = makeProxy(index)

         if not ... then
            self[index] = proxy
         end

         return proxy
      end
   end

   return module
end

local vx = setmetatable({
   name = "vx_lib",
   context = context,
   serverConfig = context == "server" and export:getServerConfig() or {},
   sharedConfig = export:getSharedConfig(),
   frameworkResource = export:getFramework(),
   inventoryResource = export:getInventory(),
   targetResource = export:getTarget(),
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

if vx.frameworkResource == "es_extended" then
   _ENV.ESX = exports[vx.frameworkResource]:getSharedObject()
elseif vx.frameworkResource == "qb-core" then
   _ENV.QBCore = exports[vx.frameworkResource]:GetCoreObject()
   RegisterNetEvent(("QBCore:%s:UpdateObject"):format(context), function()
      _ENV.QBCore = exports[vx.frameworkResource]:GetCoreObject()
   end)
end
