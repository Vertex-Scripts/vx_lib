vx.bridge = {}

local function reverseContext(context)
   return vx.ternary(context == "client", "server", "client")
end

local function callWithoutSource(func, ...)
   local arguments = { ... }
   local source = arguments[1]
   if vx.context == "client" then
      return func(source, ...)
   end

   if #arguments <= 0 then
      return func(source)
   end

   table.remove(arguments, 1)
   table.insert(arguments, source)
   return func(table.unpack(arguments))
end

---------------
-- Callbacks --
---------------

local function createCallbackHandler(self, name, func)
   rawset(self, name, func)

   local callback = vx.bridge.createEventName(vx.cache.resource, vx.context, name)
   vx.callback.register(callback, function(...)
      return callWithoutSource(func, ...)
   end)
end

local function createCallbackCaller(_, key)
   local callback = vx.bridge.createEventName(vx.cache.resource, reverseContext(vx.context), key)
   return function(...)
      local args = { ... }
      local playerId = args[1]

      if vx.context == "server" then
         table.remove(args, 1)
         return vx.callback.await(callback, playerId, table.unpack(args))
      else
         return vx.callback.await(callback, false, table.unpack(args))
      end
   end
end

------------
-- Events --
------------

local function createEventHandler(self, name, func)
   rawset(self, name, func)

   local event = vx.bridge.createEventName(vx.cache.resource, vx.context, name)
   RegisterNetEvent(event, function(...)
      if vx.context == "server" then
         func(..., source)
      else
         func(nil, ...)
      end
   end)
end

local function createEventCaller(_, key)
   local event = vx.bridge.createEventName(vx.cache.resource, reverseContext(vx.context), key)
   return function(...)
      local triggerEvent = vx.ternary(vx.context == "client", TriggerServerEvent, TriggerClientEvent)
      return triggerEvent(event, ...)
   end
end

---------
-- API --
---------

local function createBridge(createHandler, createCaller)
   return setmetatable({}, {
      __newindex = createHandler,
      __call = createCaller,
      __index = createCaller
   })
end

---@param resourceName string
---@param context "client" | "server"
---@param funcName string
---@return string
function vx.bridge.createEventName(resourceName, context, funcName)
   return ("%s:%s:%s"):format(resourceName, context, funcName)
end

function vx.bridge.createCallbackBridge()
   return createBridge(createCallbackHandler, createCallbackCaller)
end

function vx.bridge.createEventBridge()
   return createBridge(createEventHandler, createEventCaller)
end

return vx.bridge
