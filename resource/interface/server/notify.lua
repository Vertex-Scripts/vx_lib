---@param options NotificationOptions
---@diagnostic disable-next-line: duplicate-set-field
function vx.notify(source, options)
   source = tonumber(source) or 0
   if source < 1 then
      return
   end

   TriggerClientEvent("vx_lib:notify", source, options)
end
