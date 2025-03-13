local currentTextUi = ""

---@param text string
---@param type? "success" | "error" | "info"
function vx.showTextUi(text, type)
   type = type or "info"

   if currentTextUi == text then return end
   currentTextUi = text

   if vx.textuiResource == "ox_lib" then
      lib.showTextUI(text)
   elseif vx.textuiResource == "es_extended" then
      ESX.TextUI(text, type)
   elseif vx.textuiResource == "qb-core" then
      exports['qb-core']:DrawText(text, "right")
   end
end

function vx.hideTextUi()
   if vx.textuiResource == "ox_lib" then
      lib.hideTextUI()
   elseif vx.textuiResource == "es_extended" then
      ESX.HideUI()
   elseif vx.textuiResource == "qb-core" then
      exports['qb-core']:HideText()
   end

   currentTextUi = ""
end
