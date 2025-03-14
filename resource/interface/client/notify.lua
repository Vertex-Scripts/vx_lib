---@class NotificationOptions
---@field message string
---@field title? string
---@field duration? number
---@field icon? string
---@field type? "info" | "success" | "error"

---@param options NotificationOptions
---@diagnostic disable-next-line: duplicate-set-field
function vx.notify(options)
   if vx.notifyResource == "ox_lib" then
      lib.notify({
         title = options.title,
         description = options.message,
         type = options.type,
         duration = options.duration
      })
   elseif vx.notifyResource == "es_extended" then
      ESX.ShowNotification(options.message, options.type, options.duration)
   elseif vx.notifyResource == "qb-core" then
      QBCore.Functions.Notify(options.message, options.type, options.duration)
   end
end

RegisterNetEvent("vx_lib:notify", vx.notify)
