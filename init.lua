local resourceName = GetCurrentResourceName()
local context = IsDuplicityVersion() and "server" or "client"
local export = exports["vx_lib"]
local intervals = {}

local frameworkResourceMap = {
   ["esx"] = "es_extended",
   ["qb"] = "qb-core"
}

local framework = export:getFramework()
local inventory = export:getInventory()
local target = export:getTarget()
local notify = export:getNotify()

local function loadResourceFile(root, module)
   local dir = ("%s/%s"):format(root, module)
   local chunk = LoadResourceFile("vx_lib", ("%s/%s.lua"):format(dir, context))
   local shared = LoadResourceFile("vx_lib", ("%s/shared.lua"):format(dir))

   return root, chunk, shared
end

local function loadModule(self, module)
   local dir, chunk, shared = loadResourceFile("modules", module)
   if not chunk and not shared then
      dir, chunk, shared = loadResourceFile("bridge", module)
   end

   if shared then
      chunk = (chunk and ("%s\n%s"):format(shared, chunk)) or shared
   end

   if chunk then
      local fn, err = load(chunk, ("@@vx_lib/%s/%s/%s.lua"):format(dir, module, context))
      if not fn or err then
         return error(("Failed to load module %s: %s"):format(module, err))
      end

      local result = fn()
      self[module] = result

      return self[module]
   end
end

local function call(self, index, ...)
   local module = rawget(self, index)
   if not module then
      self[index] = noop
      module = loadModule(self, index)

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

local function initializeFramework(framework)
   local frameworkResourceName = frameworkResourceMap[framework]
   if framework == "esx" then
      _ENV.ESX = exports[frameworkResourceName]:getSharedObject()
   elseif framework == "qb" then
      _ENV.QBCore = exports[frameworkResourceName]:GetCoreObject()

      RegisterNetEvent(("QBCore:%s:UpdateObject"):format(context), function()
         _ENV.QBCore = exports[frameworkResourceName]:GetCoreObject()
      end)
   end
end

local vx = setmetatable({
   name = "vx_lib",
   systems = {
      framework = framework,
      inventory = inventory,
      target = target,
   },
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

---@param callback function | number
---@param interval? number
---@param ... any
function SetInterval(callback, interval, ...)
   interval = interval or 0

   if type(interval) ~= 'number' then
      return error(('Interval must be a number. Received %s'):format(json.encode(interval --[[@as unknown]])))
   end

   local cbType = type(callback)
   if cbType == 'number' and intervals[callback] then
      intervals[callback] = interval or 0
      return
   end

   if cbType ~= 'function' then
      return error(('Callback must be a function. Received %s'):format(cbType))
   end

   local args, id = { ... }
   Citizen.CreateThreadNow(function(ref)
      id = ref
      intervals[id] = interval or 0
      repeat
         interval = intervals[id]
         Wait(interval)
         callback(table.unpack(args))
      until interval < 0
      intervals[id] = nil
   end)

   return id
end

---@param id number
function ClearInterval(id)
   if type(id) ~= 'number' then
      return error(('Interval id must be a number. Received %s'):format(json.encode(id --[[@as unknown]])))
   end

   if not intervals[id] then
      return error(('No interval exists with id %s'):format(id))
   end

   intervals[id] = -1
end

_ENV.vx = vx
require = vx.require
initializeFramework(framework)
