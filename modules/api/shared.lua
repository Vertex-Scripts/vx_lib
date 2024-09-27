vx.api = {}

local currentContext = IsDuplicityVersion() and "server" or "client"

local function createCallbackName(context, funcName)
   return ("%s_%s_%s"):format(vx.cache.resource, context, funcName)
end

local function reverseContext(context)
   return vx.ternary(context == "client", "server", "client")
end

local function callApi(_, key)
   local callbackName = createCallbackName(reverseContext(currentContext), key)
   return function(...)
      local arguments = { ... }
      local fromClient = currentContext == "client"
      local playerId = arguments[1]

      return vx.callback.await(callbackName, vx.ternary(fromClient, delay, playerId), table.unpack(arguments))
   end
end

function vx.api.createApi()
   return setmetatable({}, {
      __newindex = function(self, funcName, func)
         rawset(self, funcName, func)

         local callbackName = createCallbackName(currentContext, funcName)
         vx.callback.register(callbackName, function(source, ...)
            if currentContext == "client" then
               return func(nil, source, ...)
            end

            local arguments = { ... }
            if #arguments <= 0 then
               return func(source)
            end

            return func(..., source)
         end)
      end
   })
end

function vx.api.createCaller()
   return setmetatable({}, {
      __call = callApi,
      __index = callApi
   })
end

return vx.api
