--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright (c) 2025 Linden <https://github.com/thelindat/fivem>
]]

local events = {}
local cbEvent = ('__vx_cb_%s')

RegisterNetEvent(cbEvent:format(vx.cache.resource), function(key, ...)
   local cb = events[key]
   return cb and cb(...)
end)

---@param _ any
---@param event string
---@param playerId number
---@param cb function|false
---@param ... any
---@return ...
local function triggerClientCallback(_, event, playerId, cb, ...)
   local key

   repeat
      key = ('%s:%s:%s'):format(event, math.random(0, 100000), playerId)
   until not events[key]

   TriggerClientEvent(cbEvent:format(event), playerId, vx.cache.resource, key, ...)

   ---@type promise | false
   local promise = not cb and promise.new()

   events[key] = function(response, ...)
      response = { response, ... }
      events[key] = nil

      if promise then
         return promise:resolve(response)
      end

      if cb then
         cb(table.unpack(response))
      end
   end

   if promise then
      return table.unpack(Citizen.Await(promise))
   end
end

---@overload fun(event: string, playerId: number, cb: function, ...)
vx.callback = setmetatable({}, {
   __call = triggerClientCallback
})

local function callbackResponse(success, result, ...)
   if not success then
      if result then
         return print(('^1SCRIPT ERROR: %s^0\n%s'):format(result,
            Citizen.InvokeNative(`FORMAT_STACK_TRACE` & 0xFFFFFFFF, nil, 0, Citizen.ResultAsString()) or ''))
      end

      return false
   end

   return result, ...
end

---@param event string
---@param playerId number
--- Sends an event to a client and halts the current thread until a response is returned.
---@diagnostic disable-next-line: duplicate-set-field
function vx.callback.await(event, playerId, ...)
   return triggerClientCallback(nil, event, playerId, false, ...)
end

---@param name string
---@param cb function
--- Registers an event handler and callback function to respond to client requests.
---@diagnostic disable-next-line: duplicate-set-field
function vx.callback.register(name, cb)
   RegisterNetEvent(cbEvent:format(name), function(resource, key, ...)
      TriggerClientEvent(cbEvent:format(resource), source, key, callbackResponse(pcall(cb, source, ...)))
   end)
end

return vx.callback
