local textUiSystem = GetConvar("vx:textui", "auto")
local isOpen = false

function vx.showTextUI(text)
   if textUiSystem == "ox" then
      if isOpen then
         TriggerEvent("ox_inventory:closeTextUI")
      end
      TriggerEvent("ox_inventory:showTextUI", text)
      isOpen = true
   elseif textUiSystem == "custom" then
      error("TODO")
   elseif textUiSystem == "auto" then
      error("TODO")
   else
      error(("invalid textui system in vx:textui expected 'ox' or 'custom' (received %s)"):format(textUiSystem))
   end
end
