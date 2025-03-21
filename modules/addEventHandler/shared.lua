---@param eventName string
---@param eventRoutine function
---@return { key: number, name : string}
function vx.addEventHandler(eventName, eventRoutine)
   return AddEventHandler(eventName, eventRoutine)
end

return vx.addEventHandler
