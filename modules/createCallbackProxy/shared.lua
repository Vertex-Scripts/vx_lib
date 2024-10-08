local function createCallbackName(context, funcName)
   return ("%s_%s_%s"):format(vx.cache.resource, context, funcName)
end

local function reverseContext(context)
   return vx.ternary(context == "client", "server", "client")
end

local function createProxiedCallback(self, name, func)
   rawset(self, name, func)

   local callback = createCallbackName(vx.context, name)
   vx.callback.register(callback, function(source, ...)
      if vx.context == "client" then
         return func(nil, source, ...)
      end

      local arguments = { ... }
      if #arguments <= 0 then
         return func(source)
      end

      return func(..., source)
   end)
end

local function callProxiedCallback(_, key)
   local callback = createCallbackName(reverseContext(vx.context), key)
   return function(...)
      local arguments = { ... }
      local fromClient = vx.context == "client"
      local playerId = arguments[1]
      local delay = false

      return vx.callback.await(callback, vx.ternary(fromClient, delay, playerId), table.unpack(arguments))
   end
end

function vx.createCallbackProxy()
   return setmetatable({}, {
      __newindex = createProxiedCallback,
      __call = callProxiedCallback,
      __index = callProxiedCallback
   })
end

return vx.createCallbackProxy
