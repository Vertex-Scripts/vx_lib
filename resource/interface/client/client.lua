---@class NotificationOptions
---@field message string
---@field title? string
---@field duration? number
---@field type? "info" | "success" | "error"

---@param options NotificationOptions
function vx.notify(options)
   local duration = options.duration or 5000
   local type = options.type or "info"

   local notifySystem = vx.config.notification
   if notifySystem == "ox" then
      ---@type NotifyProps
      local oxOptions = {
         title = options.title,
         description = options.message,
         type = options.type,
         duration = duration
      }

      TriggerEvent("ox_lib:notify", oxOptions)
   elseif notifySystem == "esx" then
      ESX.ShowNotification(options.message, type, duration)
   elseif notifySystem == "qb" then
      -- TODO: Implement QB notify
      error("TODO")
   elseif notifySystem == "custom" then
      error("TODO")
   else
      error(("invalid notification system in configuration expected 'ox', 'esx', 'qb', or 'custom' (received %s)")
         :format(
            notifySystem))
   end
end

return vx.notify
