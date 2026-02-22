vx.events = {}

--- @param cb fun(playerId: number, reason: string, resourceName: string, clientDropReason: number)
function vx.events.onPlayerLeave(cb)
   vx.addEventHandler("playerDropped", function(...)
      local playerId = source
      cb(playerId, ...)
   end)
end

return vx.events
