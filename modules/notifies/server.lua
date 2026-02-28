vx.notifies = {}

local function sendNotification(source, type, message, options)
   options = options or {}

   vx.notify(source, {
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
function vx.notifies.error(source, message, options)
   sendNotification(source, "error", message, options)
   return false
end

---@param message string
---@param options? NotificationOptions
---@diagnostic disable-next-line: duplicate-set-field
function vx.notifies.success(source, message, options)
   sendNotification(source, "success", message, options)
   return false
end

---@param message string
---@param options? NotificationOptions
---@diagnostic disable-next-line: duplicate-set-field
function vx.notifies.info(source, message, options)
   sendNotification(source, "info", message, options)
   return false
end

---@param message string
---@param options? NotificationOptions
---@diagnostic disable-next-line: duplicate-set-field
function vx.notifies.warn(source, message, options)
   sendNotification(source, "warn", message, options)
   return false
end

return vx.notifies
