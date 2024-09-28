---@deprecated DO NOT USE, WILL BE REMOVED SOON
vx.api = {}

function vx.api.createApi()
   return vx.createCallbackProxy()
end

function vx.api.createCaller()
   return vx.createCallbackProxy()
end

return vx.api
