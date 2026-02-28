vx.events = {}

--- @param cb fun(playerId: number, reason: string, resourceName: string, clientDropReason: number)
function vx.events.onPlayerLeave(cb)
   vx.addEventHandler("playerDropped", function(...)
      local playerId = source
      cb(playerId, ...)
   end)
end

--- @param cb fun(playerId: number, name: string, setKickReason: fun(reason: string), deferrals: any)
function vx.events.onPlayerConnecting(cb)
   vx.addEventHandler("playerConnecting", function(name, setKickReason, deferrals)
      local source = source
      cb(source, name, setKickReason, deferrals)
   end)
end

---@param cb fun(resourceName: string)
function vx.events.onResourceStart(cb)
   vx.addEventHandler("onResourceStart", cb)
end

---@param cb fun(resourceName: string)
function vx.events.onResourceStop(cb)
   vx.addEventHandler("onResourceStop", cb)
end

return vx.events
