--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright (c) 2025 Linden <https://github.com/thelindat/fivem>
]]

---Yields the current thread until a non-nil value is returned by the function.
---@generic T
---@param cb fun(): T?
---@param errMessage string?
---@param timeout? number | false Error out after `~x` ms. Defaults to 1000, unless set to `false`.
---@return T
---@async
function vx.waitFor(cb, errMessage, timeout)
   timeout = timeout or 1000

   local value = cb()
   if value ~= nil then return value end

   local start = timeout and GetGameTimer()
   while value == nil do
      Citizen.Wait(0)

      local elapsed = timeout and GetGameTimer() - start
      if elapsed and elapsed > timeout then
         return error(('%s (waited %.1fms)'):format(errMessage or 'failed to resolve callback', elapsed), 2)
      end

      value = cb()
   end

   return value
end

return vx.waitFor
