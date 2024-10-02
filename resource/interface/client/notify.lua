local notifyConvar = GetConvar("vx:notification", "auto")
local notifyResources = vx.array:new("es_extended", "qb-core", "ox_lib", "custom")

local function detectNotify()
   if notifyConvar ~= "auto" then return notifyConvar end
   if GetResourceState("ox_lib") ~= "missing" then return "ox_lib" end
   if GetResourceState("es_extended") ~= "missing" then return "es_extended" end
   if GetResourceState("qb-core") ~= "missing" then return "qb-core" end

   return "custom"
end

local notify = detectNotify()
if not notifyResources:contains(notify) then
   error(("Invalid notification system in vx:notification expected 'es_extended', 'qb-core', 'ox_lib' or 'auto' (received %s)")
      :format(notify))
end

---@class NotificationOptions
---@field message string
---@field title? string
---@field duration? number
---@field icon? string
---@field type? "info" | "success" | "error"

---@param options NotificationOptions
---@diagnostic disable-next-line: duplicate-set-field
function vx.notify(options)
   vx.caller.create(notify, {
      ["es_extended"] = function()
         ESX.ShowNotification(options.message, options.type, options.duration)
      end,
      ["qb-core"] = function()
         QBCore.Functions.Notify(options.message, options.type, options.duration)
      end,
      ["ox_lib"] = function()
         lib.notify({
            title = options.title,
            description = options.message,
            type = options.type,
            duration = options.duration
         })
      end,
   })()
end

RegisterNetEvent("vx_lib:notify", vx.notify)
