---@class NotificationOptions
---@field message string
---@field title? string
---@field duration? number
---@field icon? string
---@field type? "info" | "success" | "error"

---@param options NotificationOptions
function vx.notify(options)
   local system = vx.getNotify()
   vx.caller.create(system, {
      ["esx"] = function()
         ESX.ShowNotification(options.message, options.type, options.duration)
      end,
      ["qb"] = function()
         QBCore.Functions.Notify(options.message, options.type, options.duration)
      end,
      ["ox"] = function()
         TriggerEvent("ox_lib:notify", {
            title = options.title,
            description = options.message,
            type = options.type,
            duration = options.duration
         })
      end,
   })()
end

return vx.notify
