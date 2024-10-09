local function reverseContext(context)
   return vx.ternary(context == "client", "server", "client")
end

function createCallbackName(name, scope)
   return ("%s:%s:%s:%s"):format(vx.cache.resource, reverseContext(vx.context), scope, name)
end

local function createProxiedCallback(self, name, value)
   rawset(self, name, value)

   if type(value) ~= "function" then
      return
   end

   local callback = createCallbackName(name, self.__name or "root")
   vx.print.info(name, callback, value)

   vx.callback.register(callback, function(source, ...)
      if vx.context == "client" then
         return value(source, ...)
      end

      local arguments = { ... }
      if #arguments <= 0 then
         return value(source)
      end

      return value(..., source)
   end)
end

local function callProxiedCallback(self, key)
   local callback = createCallbackName(self.name or "root", key)
   return function(...)
      local arguments = { ... }
      local fromClient = vx.context == "client"
      local playerId = arguments[1]
      local delay = false

      return vx.callback.await(callback, vx.ternary(fromClient, delay, playerId), table.unpack(arguments))
   end
end

local function createDynamicProxy(name)
   return setmetatable({ __name = name }, {
      __newindex = createProxiedCallback,
      __call = callProxiedCallback,
      __index = function(self, key)
         local newName = ("%s:%s"):format(self.__name or "root", key)
         rawset(self, key, createDynamicProxy(newName))

         return rawget(self, key)
      end
   })
end

---@param name? string
function vx.createCallbackProxy(name)
   return createDynamicProxy(name or "root")
end

return vx.createCallbackProxy
