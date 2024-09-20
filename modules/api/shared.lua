vx.api = {}

local currentContext = IsDuplicityVersion() and "server" or "client"

local function createCallbackName(context, funcName)
   return ("%s_%s_%s"):format(vx.cache.resource, context, funcName)
end

local function callApi(self, key)
   local callbackName = createCallbackName(self.context, key)
   return function(...)
      local arguments = { ... }
      local isClient = self.context == "client"
      local playerId = arguments[1]
      if isClient then
         table.remove(arguments, 1)
      end

      return vx.callback.await(callbackName, isClient and false or playerId, table.unpack(arguments))
   end
end

function vx.api.createApi()
   return setmetatable({}, {
      __newindex = function(self, funcName, func)
         rawset(self, funcName, func)

         local callbackName = createCallbackName(currentContext, funcName)
         vx.callback.register(callbackName, function(source, ...)
            local arguments = { ... }
            if #arguments <= 0 then
               return func(source)
            end

            return func(..., source)
         end)
      end
   })
end

---@param context? "server" | "client"
function vx.api.createCaller(context)
   return setmetatable({
      context = context or (currentContext == "server" and "client" or "server")
   }, {
      __call = callApi,
      __index = callApi
   })
end

return vx.api
