local currentTextUi = ""

---@todo Implement for qb
---@param text string
---@param type? "success" | "error" | "info"
function vx.showTextUi(text, type)
   type = type or "info"

   if vx.textuiResource == "ox_lib" then
      lib.showTextUI(text, {
         style = type
      })
   elseif vx.textuiResource == "es_extended" then
      ESX.TextUI(text, type)
   elseif vx.textuiResource == "qb-core" then
      if currentTextUi == text then return end

      currentTextUi = text
      exports['qb-core']:DrawText(text, "right")
      print('set')
   end
end

function vx.hideTextUi()
   if vx.textuiResource == "ox_lib" then
      lib.hideTextUI()
   elseif vx.textuiResource == "es_extended" then
      ESX.HideUI()
   elseif vx.textuiResource == "qb-core" then
      exports['qb-core']:HideText()
      currentTextUi = ""
   end
end
