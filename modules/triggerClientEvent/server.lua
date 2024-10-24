---@param eventName string
---@param targets number|number[]
function vx.triggerClientEvent(eventName, targets, ...)
   local payload = msgpack.pack_args(...)
   local payloadLen = #payload

   if type(target) == "table" then
      for i = 1, #targets do
         TriggerClientEventInternal(eventName, targets[i] --[[@as string]], payload, payloadLen)
      end

      return
   end

   TriggerClientEventInternal(eventName, targets --[[@as string]], payload, payloadLen)
end

return vx.triggerClientEvent
