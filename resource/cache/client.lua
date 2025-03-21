--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright (c) 2025 Linden <https://github.com/thelindat/fivem>
]]

vx.cache.playerId = PlayerId()
vx.cache.serverId = GetPlayerServerId(vx.cache.playerId)

function vx.cache:set(key, value)
   if value == self[key] then
      return
   end

   TriggerEvent(("vx:cache:set:%s"):format(key), value, self[key])
   self[key] = value
end

CreateThread(function()
   while true do
      local ped = PlayerPedId()
      vx.cache:set("ped", ped)

      local vehicle = GetVehiclePedIsIn(ped, false)
      if vehicle > 0 then
         vx.cache:set("vehicle", vehicle)
      else
         vx.cache:set("vehicle", nil)
      end

      Citizen.Wait(100)
   end
end)

function vx.getFromCache(key)
   return vx.cache[key]
end
