---@param options NotificationOptions
---@diagnostic disable-next-line: duplicate-set-field
function vx.notify(source, options)
   TriggerClientEvent("vx_lib:notify", source, options)
end
