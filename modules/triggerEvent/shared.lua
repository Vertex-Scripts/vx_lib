---Triggers an event, sending additional parameters as arguments.
---[Documentation](https://docs.fivem.net/docs/scripting-manual/working-with-events/triggering-events/)
---@param eventName string
function vx.triggerEvent(eventName, ...)
   return TriggerEvent(eventName, ...)
end

return vx.triggerEvent
