local textUiSystem = GetConvar("vx:textUi", "auto")
local textUiMap = { "esx", "qb", "ox", "custom" }

local function detectTextUi()
   if textUiSystem ~= "auto" then return textUiSystem end
   if GetResourceState("ox_lib") ~= "missing" then return "ox" end
   if GetResourceState("es_extended") ~= "missing" then return "esx" end
   if GetResourceState("qb-core") ~= "missing" then return "qb" end

   return "custom"
end

local textUi = detectTextUi()

local function isValidTextUi()
   for _, ns in pairs(textUiMap) do
      if ns == textUi then
         return true
      end
   end

   return false
end

if not isValidTextUi() then
   error(("Invalid textUi system in vx:textUi expected 'ox', 'esx', 'qb', 'vx' or 'custom' (received %s)")
      :format(textUi))
end

---@todo Implement for others
function vx.showTextUi(text)
   vx.caller.create(textUi, {
      ["ox"] = function()
         lib.showTextUI(text)
      end
      -- ["esx"] = function()
      --    ESX.ShowNotification(options.message, options.type, options.duration)
      -- end,
      -- ["qb"] = function()
      --    QBCore.Functions.Notify(options.message, options.type, options.duration)
      -- end,
      -- ["ox"] = function()
      --    TriggerEvent("ox_lib:notify", {
      --       title = options.title,
      --       description = options.message,
      --       type = options.type,
      --       duration = options.duration
      --    })
      -- end,
   })()
end
