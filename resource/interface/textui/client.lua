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

---@todo Implement for qb
---@param text string
---@param type? "success" | "error" | "info"
function vx.showTextUi(text, type)
   type = type or "info"

   vx.caller.create(textUi, {
      ["ox"] = function()
         lib.showTextUI(text)
      end,
      ["esx"] = function()
         ESX.TextUI(text, type)
      end,
      -- ["qb"] = function()

      -- end,
   })()
end

function vx.hideTextUi()
   vx.caller.create(textUi, {
      ["ox"] = function()
         lib.hideTextUI()
      end,
      ["esx"] = function()
         ESX.HideUI()
      end,
      -- ["qb"] = function()

      -- end,
   })()
end
