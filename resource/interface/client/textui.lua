-- TODO !!!!!!!!!!!!!

local textUiConvar = GetConvar("vx:textUi", "auto")
local textUiResources = vx.array:new("es_extended", "qb-core", "ox_lib", "custom")

local function detectTextUi()
   if textUiConvar ~= "auto" then return textUiConvar end
   if GetResourceState("ox_lib") ~= "missing" then return "ox_lib" end
   if GetResourceState("es_extended") ~= "missing" then return "es_extended" end
   if GetResourceState("qb-core") ~= "missing" then return "qb-core" end

   return "custom"
end

local textUi = detectTextUi()
if not textUiResources:contains(textUi) then
   error(("Invalid textUi system in vx:textUi expected 'es_extended', 'qb-core', 'ox_lib' or 'auto' (received %s)")
      :format(textUi))
end

---@todo Implement for qb
---@param text string
---@param type? "success" | "error" | "info"
function vx.showTextUi(text, type)
   type = type or "info"

   vx.caller.create(textUi, {
      ["es_extended"] = function()
         ESX.TextUI(text, type)
      end,
      ["ox_lib"] = function()
         lib.showTextUI(text)
      end,
   })()
end

function vx.hideTextUi()
   vx.caller.create(textUi, {
      ["es_extended"] = function()
         ESX.HideUI()
      end,
      ["ox_lib"] = function()
         lib.hideTextUI()
      end,
   })()
end
