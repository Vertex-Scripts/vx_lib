---@param eventName string
---@param cb? function trigger a coroutine when the event is called.
---@return { key: number, name : string}?
function vx.registerNetEvent(eventName, cb)
   return RegisterNetEvent(eventName, cb)
end

return vx.registerNetEvent
