vx.notifies = {}

local function sendNotification(type, message, options)
   options = options or {}

   vx.notify({
      type = type or "info",
      title = options.title or vx.sharedConfig.defaulNotificationTitles[type] or "Info",
      message = message,
      duration = options.duration or 5000,
      icon = options.icon,
   })
end

---@param message string
---@param options? NotificationOptions
---@diagnostic disable-next-line: duplicate-set-field
function vx.notifies.error(message, options)
   sendNotification("error", message, options)
   return false
end

---@param message string
---@param options? NotificationOptions
---@diagnostic disable-next-line: duplicate-set-field
function vx.notifies.success(message, options)
   sendNotification("success", message, options)
   return false
end

---@param message string
---@param options? NotificationOptions
---@diagnostic disable-next-line: duplicate-set-field
function vx.notifies.info(message, options)
   sendNotification("info", message, options)
   return false
end

---@param message string
---@param options? NotificationOptions
---@diagnostic disable-next-line: duplicate-set-field
function vx.notifies.warn(message, options)
   sendNotification("warn", message, options)
   return false
end

return vx.notifies
