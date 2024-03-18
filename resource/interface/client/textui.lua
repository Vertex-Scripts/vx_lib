local isOpen = false

function vx.showTextUI(text)
   if SharedConfig.textui == "ox" then
      if isOpen then
         TriggerEvent("ox_inventory:closeTextUI")
      end
      TriggerEvent("ox_inventory:showTextUI", text)
      isOpen = true
   elseif SharedConfig.textui == "custom" then
      print(text)
   else
      error(("invalid textui system in configuration expected 'ox' or 'custom' (received %s)"):format(SharedConfig
      .textui))
   end
end
