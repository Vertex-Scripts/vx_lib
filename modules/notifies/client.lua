vx.notifies = {}

local defaultTitle = "Fout!"

local defaultTitles = {
   ["error"] = "Fout!",
   ["success"] = "Succes!",
   ["info"] = "Info",
   ["warn"] = "Waarschuwing!",
}

local function sendNotification(type, message, options)
   options = options or {}

   vx.notify({
      type = type or "info",
      title = options.title or defaultTitles[type] or "Info",
      message = message,
      duration = options.duration or 5000,
      icon = options.icon,
   })
end

---@param message string
---@param options? NotificationOptions
function vx.notifies.error(message, options)
   sendNotification("error", message, options)
   return false
end

---@param message string
---@param options? NotificationOptions
function vx.notifies.success(message, options)
   sendNotification("success", message, options)
   return false
end

---@param message string
---@param options? NotificationOptions
function vx.notifies.info(message, options)
   sendNotification("info", message, options)
   return false
end

---@param message string
---@param options? NotificationOptions
function vx.notifies.warn(message, options)
   sendNotification("warn", message, options)
   return false
end

return vx.notifies
