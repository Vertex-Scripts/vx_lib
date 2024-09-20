vx.api = {}

local context = IsDuplicityVersion() and "server" or "client"

local function createCallbackName(funcName)
   return ("%s_%s_%s"):format(vx.cache.resource, context, funcName)
end

local function callApi(_, key)
   local callbackName = createCallbackName(key)
   return function(...)
      return vx.callback.await(callbackName, false, ...)
   end
end


function vx.api.createApi()
   return setmetatable({}, {
      __newindex = function(self, funcName, func)
         local callbackName = createCallbackName(funcName)
         vx.callback.register(callbackName, func)

         rawset(self, funcName, func)
      end
   })
end

function vx.api.createCaller()
   return setmetatable({}, {
      __call = callApi,
      __index = callApi
   })
end
