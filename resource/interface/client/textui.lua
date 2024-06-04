local textUiSystem = GetConvar("vx:textui", "auto")
local isOpen, oldText = false, ""

function vx.showTextUI(text, options)
   if textUiSystem == "ox" then
      if not isOpen then
         TriggerEvent("ox_lib:showTextUi", text, options)
         isOpen = true
         oldText = text
      end
   elseif textUiSystem == "esx" then
      local type = options and options.type or "info"
      if not isOpen then
         TriggerEvent("ESX:TextUI", text, type)
         isOpen = true
         oldText = text
      end
   elseif textUiSystem == "custom" then
      error("TODO")
   elseif textUiSystem == "auto" then
      error("TODO")
   else
      error(("invalid textui system in vx:textui expected 'ox' or 'custom' (received %s)"):format(textUiSystem))
   end
end

function vx.isTextUIOpen()
   return isOpen, oldText
end

function vx.hideTextUI()
   if textUiSystem == "ox" then
      if isOpen then
         TriggerEvent("ox_lib:hideTextUI")
         isOpen = false
      end
   elseif textUiSystem == "esx" then
      if isOpen then
         TriggerEvent("ESX:HideUI")
         isOpen = false
      end
   elseif textUiSystem == "custom" then
      error("TODO")
   elseif textUiSystem == "auto" then
      error("TODO")
   else
      error(("invalid textui system in vx:textui expected 'ox' or 'custom' (received %s)"):format(textUiSystem))
   end
end