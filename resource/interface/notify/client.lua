local notifySystem = GetConvar("vx:notification", "auto")
local notifyMap = { "esx", "qb", "ox", "custom" }

local function detectNotify()
   if notifySystem ~= "auto" then return notifySystem end
   if GetResourceState("ox_lib") ~= "missing" then return "ox" end
   if GetResourceState("es_extended") ~= "missing" then return "esx" end
   if GetResourceState("qb-core") ~= "missing" then return "qb" end

   return "custom"
end

local notify = detectNotify()

local function isValidNotify()
   for _, ns in pairs(notifyMap) do
      if ns == notify then
         return true
      end
   end

   return false
end

if not isValidNotify() then
   error(("Invalid notification system in vx:notification expected 'ox', 'esx', 'qb' or 'custom' (received %s)")
      :format(notify))
end

---@class NotificationOptions
---@field message string
---@field title? string
---@field duration? number
---@field icon? string
---@field type? "info" | "success" | "error"

---@param options NotificationOptions
function vx.notify(options)
   vx.caller.create(notify, {
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
