--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright (c) 2025 Linden <https://github.com/thelindat/fivem>
]]

---@param eventName string
---@param targets number|number[]
function vx.triggerClientEvent(eventName, targets, ...)
   local payload = msgpack.pack_args(...)
   local payloadLen = #payload

   if type(targets) == "table" then
      for i = 1, #targets do
         TriggerClientEventInternal(eventName, targets[i] --[[@as string]], payload, payloadLen)
      end

      return
   end

   TriggerClientEventInternal(eventName, targets --[[@as string]], payload, payloadLen)
end

return vx.triggerClientEvent
